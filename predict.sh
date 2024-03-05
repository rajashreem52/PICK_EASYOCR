#!/bin/bash

image_filename=""
image_folder=""
output_folder="output_folder"
checkpoint_path="PICK_Default/test_1221_004907/model_best.pth"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --image_filename)
            image_filename="$2"
            shift 2
            ;;
        --image_folder)
            image_folder="$2"
            shift 2
            ;;
        --output_folder)
            output_folder="$2"
            shift 2
            ;;
        --checkpoint)
            checkpoint_path="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check if either image_filename or image_folder is provided
if [ -z "$image_filename" ] && [ -z "$image_folder" ]; then
    echo "Usage: $0 (--image_filename <image_filename> | --image_folder <image_folder>) [--output_folder <output_folder>] [--checkpoint <checkpoint_path>]"
    exit 1
fi

if [ -n "$image_filename" ] && [ -n "$image_folder" ]; then
    echo "Error: Please provide either --image_filename or --image_folder, but not both."
    exit 1
fi

# If image_folder is provided, run easy_ocr.py for each image in the folder
if [ -n "$image_folder" ]; then
    for file in "$image_folder"/*; do
        if [ -f "$file" ]; then
            python3 easy_ocr.py --image_filename "$file"

            # Check the exit status of easy_ocr.py
            if [ $? -ne 0 ]; then
                echo "Error in easy_ocr.py. Exiting."
                exit 1
            fi
        fi
    done
else
    # If only image_filename is provided, run easy_ocr.py single time
    python3 easy_ocr.py --image_filename "$image_filename"

    # Check the exit status of easy_ocr.py
    if [ $? -ne 0 ]; then
        echo "Error in easy_ocr.py. Exiting."
        exit 1
    fi
fi

# Run the second Python script with the specified arguments
python3 test.py --checkpoint ~/PICK-pytorch/saved/models/"$checkpoint_path" \
                --boxes_transcripts ~/PICK-pytorch/input/boxes_trans \
                --images_path  ~/PICK-pytorch/input/images \
                --output_folder ~/PICK-pytorch/"$output_folder" \
                --gpu 1 \
                --batch_size 2
