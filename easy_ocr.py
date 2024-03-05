import argparse
import easyocr
import os
import cv2
import sys
import shutil

def perform_ocr(image_filename):
    reader = easyocr.Reader(['en'])
    result = reader.readtext(image_filename)
    save_ocr_info_to_tsv(result, image_filename)

def save_ocr_info_to_tsv(results, image_filename, output_folder='input'):
    # Remove the existing output folder if it exists
    if os.path.exists(output_folder):
        shutil.rmtree(output_folder)

    # Create the output folder
    os.makedirs(output_folder)

    boxes_trans_folder = os.path.join(output_folder, 'boxes_trans')
    images_folder = os.path.join(output_folder, 'images')

    os.makedirs(boxes_trans_folder, exist_ok=True)
    os.makedirs(images_folder, exist_ok=True)

    base_name, extension = os.path.splitext(os.path.basename(image_filename))
    output_file = os.path.join(boxes_trans_folder, f"{base_name}.tsv")

    # Copy the original image to the 'images' folder
    shutil.copy(image_filename, os.path.join(images_folder, f"{base_name}{extension}"))

    with open(output_file, 'w') as file:
        for index, (bounding_box, text, confidence) in enumerate(results):
            x1, y1 = bounding_box[0]
            x2, y2 = bounding_box[1]
            x3, y3 = bounding_box[2]
            x4, y4 = bounding_box[3]
            line = f"{index},{x1},{y1},{x2},{y2},{x3},{y3},{x4},{y4},{text}\n"
            file.write(line)

def main():
    parser = argparse.ArgumentParser(description='Perform OCR on an image.')
    parser.add_argument('--image_filename', required=True, help='Path to the input image file.')
    args = parser.parse_args()

    perform_ocr(args.image_filename)

if __name__ == "__main__":
    main()
