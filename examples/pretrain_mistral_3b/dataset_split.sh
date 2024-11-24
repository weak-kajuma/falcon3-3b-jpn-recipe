#! /bin/bash

# Please run the command "cd examples/pretrain_mistral_3b/ ; bash dataset.sh true"

readonly DATA_DIR="./results/dataset/"

# set log
mkdir -p ./results/log/$(basename "$0" .sh)
log=./results/log/$(basename "$0" .sh)/$(date +%Y%m%d_%H%M%S).log
exec &> >(tee -a $log)
set -x

mkdir -p $DATA_DIR

python ../../source/dataset/split_dataset.py \
    --input_file ./results/dataset/train.jsonl \
    --split_ratio 0.8

    # --input_file ../../source/dataset/wiki.jsonl \


set +x