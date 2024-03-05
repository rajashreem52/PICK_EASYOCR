#!/bin/bash

CUDA_VISIBLE_DEVICES=0,1 python3 -m torch.distributed.launch --nnodes=1 --node_rank=0 --nproc_per_node=2 --master_addr=127.0.0.1 --master_port=5555 train.py -c config.json --local_world_size 2
