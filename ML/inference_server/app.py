from fastapi import FastAPI, File, UploadFile
from typing import Annotated
import torch
from torchvision import models, transforms
from torch import nn
from PIL import Image
import pickle

# 모델정의
class ResNet50Classifier(nn.Module):
    def __init__(self, num_classes=5087, freeze_resnet=False):
        super(ResNet50Classifier, self).__init__()
        
        # Resnet50 model
        # pretrained 모델 사용
        self.backborn = models.resnet50(pretrained=False)
        
        # pretrained weight freeze 여부
        if freeze_resnet:
            for param in self.backborn.parameters():
                param.requires_grad = False
        
        # resnet50 출력채널수
        num_features = self.backborn.fc.in_features
        
        # resnet50의 마지막 출력채널을 제거
        self.backborn.fc = nn.Identity()
        
        # 우리가 분류할 class만큼 full connected 레이어 추가
        num_intermediate = (num_features + num_classes) // 2
        self.intermediate = nn.Linear(num_features, num_intermediate)
        self.classifier = nn.Linear(num_intermediate, num_classes)
    
    def forward(self, x):
        x = self.backborn(x)
        x = self.intermediate(x)
        x = self.classifier(x)
        return x

app = FastAPI()
model: ResNet50Classifier = torch.load("latest_model.pt", map_location=torch.device('cpu'))
softmax = nn.Softmax(dim=1)
with open("class_map.pickle", "rb") as file:
    model_output_to_itemseq = pickle.load(file)
    output_map = {value: key for key, value in model_output_to_itemseq.items()}
    

@app.get("/")
async def root():
    return {"result": "hello"}

@app.post("/inference")
async def inference(image: Annotated[bytes, File()]):
    input_image = Image.open(image)
    result = model(input_image)
    probabilities = softmax(result)
    top10_values, top10_indicies = torch.topk(probabilities, k=10, dim=1)
    return {"item_seqs": [output_map[index] for index in top10_indicies.squeeze().tolist()]}

def test_inference():
    input_image = Image.open(r"testimage.png")
    new_image = Image.new("RGBA", input_image.size, (255,255,255,255))
    new_image.paste(input_image, (0, 0), input_image)
    input_image = new_image.convert('RGB')
    input_image = input_image.resize((224, 224))
    input_image.show()
    preprocess = transforms.Compose([
        transforms.ToTensor(),  # 텐서로 변환
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),  # 정규화
        ])
    input_image = preprocess(input_image).unsqueeze(0)
    result = model(input_image)
    probabilities = softmax(result)
    top10_values, top10_indicies = torch.topk(probabilities, k=10, dim=1)
    for index in top10_indicies.squeeze().tolist():
        print(output_map[index])
    # print(model_output_to_itemseq)

if __name__ == "__main__":
    print(list(output_map.items())[:10])
    # print(test_inference())