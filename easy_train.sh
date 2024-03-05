#!/bin/bash

CUDA_VISIBLE_DEVICES=0 python3 ~/PICK-pytorch/easy/EasyOCR/deep-text-recognition-benchmark/train.py --train_data ~/PICK-pytorch/easy/EasyOCR/deep-text-recognition-benchmark/train/result --valid_data ~/PICK-pytorch/easy/EasyOCR/deep-text-recognition-benchmark/validation/result --Transformation None --FeatureExtraction VGG --SequenceModeling BiLSTM --Prediction CTC
