from rembg import remove, new_session
from PIL import Image
import os
from concurrent.futures import ProcessPoolExecutor
import concurrent.futures
import sys
from tqdm import tqdm

session = new_session("isnet-general-use")

background_fill_colors = list()
# xterm colors
background_fill_colors.append((0,0,0,255))
background_fill_colors.append((192,192,192,255))
for i in range(7):
    background_fill_colors.append((0 if i&1 else 128,0 if i&2 else 128,0 if i&4 else 128,255))
    background_fill_colors.append((0 if i&1 else 255,0 if i&2 else 255,0 if i&4 else 255,255))

def remove_background(item_seq):
    source_root = 'e:\\pill_image'
    output_root = 'e:\\pill_image_augmented'
    item_seq_imgs = os.listdir(os.path.join(source_root, item_seq))
    process_imgs = [item_seq_imgs[0], item_seq_imgs[-1]]
    output_path = os.path.join(output_root, item_seq)
    for fb_index, image_path in enumerate(process_imgs):
        image_name, image_ext = os.path.splitext(image_path)
        image = Image.open(os.path.join(source_root, item_seq, image_path))
        for index, value in tqdm(enumerate(background_fill_colors), total=16, leave=False, desc=f"{fb_index}_{item_seq}", position=0): # 각 색상당
            bg_removed_image = remove(image, bgcolor=value)
            width, height = bg_removed_image.size
            cropped_image = bg_removed_image.crop(
                ((width-1500) // 2, 
                 (height-1500)//2, 
                 (width+1500)//2,
                 (height+1500)//2)
            )
#             display(bg_removed_image)
            for rot in range(0, 360, 18): # 20장의 샘플 이미지 생성
                rotated_image = cropped_image.rotate(angle=rot, fillcolor=value).resize((224,224))
                if not os.path.exists(output_path):
                    os.makedirs(output_path, exist_ok=True)
                rotated_image.convert('RGB').save(
                    os.path.join(
                        output_path,
                        f'{item_seq}_{fb_index}_c{index:02d}_r{rot:03d}{image_ext}'))

if __name__ == "__main__":
    source_root = 'e:\\pill_image'
    output_root = 'e:\\pill_image_augmented'
    if not os.path.exists(output_root):
        os.makedirs(output_root, exist_ok=True)
    item_seqs = [ x for x in os.listdir(source_root) if os.path.isdir(os.path.join(source_root, x)) ]
    with ProcessPoolExecutor(max_workers=6) as executor:
        fs=list()
        for item_seq in item_seqs:
            fs.append(executor.submit(remove_background, item_seq))
#             remove_background(source_root, output_root, item_seq)
        with tqdm(total=len(fs), position=3) as pbar:
            for future in concurrent.futures.as_completed(fs):
                pbar.update(1)
