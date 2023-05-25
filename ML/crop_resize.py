import torch
import torch.nn as nn
import torchvision
import torchsummary
from PIL import Image
import os
from concurrent.futures import ProcessPoolExecutor
import concurrent.futures
from tqdm.auto import tqdm

def crop_resize(source_path, output_path) -> tuple[str, int]:
    processed_images = 0
    os.makedirs(output_path, exist_ok = True)
    for image_name in tqdm(os.listdir(source_path), leave=False):
        if not "jpg".lower() in image_name.lower():
            continue
        try:
            image = Image.open(os.path.join(source_path, image_name))
            new_width = 1200
            new_height = 1200
            width, height = image.size
            left = (width - new_width)/2
            top = (height - new_height)/2
            right = (width + new_width)/2
            bottom = (height + new_height)/2
            image = image.crop((left, top, right, bottom))
            new_size = (224, 224)
            image = image.resize(new_size)
            image.save(os.path.join(output_path, image_name))
            processed_images += 1
        except Exception as e:
            print(f'{source_path}: {e}', flush=True)
    return (source_path, output_path, processed_images)