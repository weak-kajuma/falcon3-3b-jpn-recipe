#! /bin/bash

# Please run the command "cd examples/pretrain_mistral_3b/ ; bash dataset.sh"

# $1 is true, or false
readonly CLEAN_CORPUS=$1
readonly DATA_DIR="./results/dataset/"

# set log
mkdir -p ./results/log/$(basename "$0" .sh)
log=./results/log/$(basename "$0" .sh)/$(date +%Y%m%d_%H%M%S).log
exec &> >(tee -a $log)
set -x

mkdir -p $DATA_DIR

if "${CLEAN_CORPUS}"; then
    ### download wikipedia, wikibooks, and cc100 corpus ###
     
    # download cc100
    echo ">>> Download japanese CC-100."
    wget http://data.statmt.org/cc-100/ja.txt.xz -P $DATA_DIR
    mkdir -p $DATA_DIR/cc100
    python ../../externals/bert-japanese/merge_split_corpora.py \
    --input_files $DATA_DIR/ja.txt.xz \
    --output_dir $DATA_DIR/cc100 \
    --num_files 64
    python ../../source/dataset/concat_sentence.py \
    --folder_path $DATA_DIR/cc100/\*.txt \
    --output_file $DATA_DIR/cc100/cc100.txt

    ### merge jsonl files ###
    # for split in "train" "test" "valid"
    # do
    # mv ./externals/corpus-cleaner/results/data/oscar/cleaned/oscar2109_ja_$split.jsonl ./results/dataset/$split.jsonl
    # cat ./externals/corpus-cleaner/results/data/cc100/cleaned/cc100_$split.jsonl >> ./results/dataset/$split.jsonl
    # cat ./externals/corpus-cleaner/results/data/wiki/cleaned/wiki_$split.jsonl >> ./results/dataset/$split.jsonl
    # #echo $split
    # done


else
    # download mistral-300m-corpus from huggingface
    echo "false"
fi
