import torch
from torchvision import models
from torch import nn
import boto3
import json

s3_client = boto3.client("s3")

S3_BUCKET_NAME = "pillbox_ml_bucket"

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

def inference(event, context):
    object_key = "latest_model.pt"
    file_content = s3_client.get_object(
        Bucket=S3_BUCKET_NAME, Key=object_key
    )["Body"].read()
    model = torch.load(file_content)
    print(type(model))
    body = {
        "message": "this is echo",
        "input": event
    }

    response = {
        "statusCode": 200,
        "body": json.dumps(body)
    }

    return response