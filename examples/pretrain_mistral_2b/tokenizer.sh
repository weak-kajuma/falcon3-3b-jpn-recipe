#! /bin/bash

# $1 is true, or false
readonly CLEAN_CORPUS=$1

# set log
mkdir -p results/log/$(basename "$0" .sh)
log=results/log/$(basename "$0" .sh)/$(date +%Y%m%d_%H%M%S).log
exec &> >(tee -a $log)
set -x

mkdir -p results/preprocess

# if "${CLEAN_CORPUS}"; then
#     # clean corpus by "corpus_cleaner"

#     #create corpus for torkenizer
#     python ./mistral/util/extract_text_of_jsonl.py \
#         --input_path="./results/dataset/train.jsonl" \
#         --output_path="./results/preprocess/tokenizer_corpus.txt"

# else
#     # create corpus for torkenizer
#     echo "else"
# fi


# create tokenizer
mkdir -p ./results/preprocess/spm
mkdir -p ./results/preprocess/llamatokenizer
python ../../source/tokenize/unigram.py \
    --model_prefix="./results/preprocess/spm" \
    --output_dir="./results/preprocess/llamatokenizer" \
    --corpus_path="./results/preprocess/tokenizer_corpus.txt"


set +x