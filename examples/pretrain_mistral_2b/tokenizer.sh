#! /bin/bash

# set log
mkdir -p results/log/$(basename "$0" .sh)
log=results/log/$(basename "$0" .sh)/$(date +%Y%m%d_%H%M%S).log
exec &> >(tee -a $log)
set -x

mkdir -p results/tokenizer

# clean corpus by "corpus_cleaner"
#create corpus for torkenizer
python ../../source/util/extract_text_of_jsonl.py \
    --input_path="./results/tokenizer/tokenizer_corpus.jsonl" \
    --output_path="./results/tokenizer/tokenizer_corpus.txt"

#rm ./results/dataset/tokenizer_corpus.jsonl#

# create tokenizer
mkdir -p ./results/tokenizer/spm
mkdir -p ./results/tokenizer/llamatokenizer
python ../../source/tokenize/unigram.py \
    --model_prefix="./results/tokenizer/spm" \
    --output_dir="./results/tokenizer/llamatokenizer" \
    --corpus_path="./results/tokenizer/tokenizer_corpus.txt"

set +x