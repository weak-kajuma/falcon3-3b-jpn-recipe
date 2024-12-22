#! /bin/bash

# Please run the command "cd examples/pretrain_mistral_2b/ ; bash dataset.sh true"

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
    # ------------------------------------------
    #   Initialize
    # ------------------------------------------
    mkdir -p ../../externals/corpus-cleaner/results/dataset/original/

    # ------------------------------------------
    #   Download wikipedia corpus
    # ------------------------------------------
    echo ">>> Download Wikipedia."
    # wget https://dumps.wikimedia.org/other/cirrussearch/20241007/jawiki-20241007-cirrussearch-content.json.gz -P $DATA_DIR
    GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/datasets/ce-lery/dataset_archive.git $DATA_DIR/dataset_archive
    cd $DATA_DIR/dataset_archive
    git lfs pull 
    mv ./jawiki-20241007-cirrussearch-content.json.gz ../ 
    mv ./jawikibooks-20241007-cirrussearch-content.json.gz ../ 
    mv ./jawikiversity-20241007-cirrussearch-content.json.gz ../ 
    cd -
    rm -r $DATA_DIR/dataset_archive

    mkdir -p $DATA_DIR/wikipedia
    python ../../externals/bert-japanese/make_corpus_wiki.py \
    --input_file $DATA_DIR/jawiki-20241007-cirrussearch-content.json.gz \
    --output_file $DATA_DIR/wiki-tohoku-corpus.txt.gz \
    --min_sentence_length 10 \
    --max_sentence_length 200 \
    --mecab_option '-r /etc/mecabrc -d /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd' #echo `mecab-config --dicdir`"/mecab-ipadic-neologd"
    python ../../externals/bert-japanese/merge_split_corpora.py \
    --input_files $DATA_DIR/wiki-tohoku-corpus.txt.gz \
    --output_dir $DATA_DIR/wikipedia \
    --num_files 8
    python ../../source/dataset/concat_sentence.py \
    --folder_path $DATA_DIR/wikipedia/\*.txt \
    --output_file $DATA_DIR/wikipedia/wiki.txt
    mv $DATA_DIR/wikipedia/wiki.txt ../../externals/corpus-cleaner/results/dataset/original/

    # ------------------------------------------
    #   Download wikibooks corpus
    # ------------------------------------------
    # download 
    echo ">>> Download WikiBooks."
    #wget https://dumps.wikimedia.org/other/cirrussearch/20241007/jawikibooks-20241007-cirrussearch-content.json.gz -P $DATA_DIR
    mkdir -p $DATA_DIR/wikibooks
    python ../../externals/bert-japanese/make_corpus_wiki.py \
    --input_file $DATA_DIR/jawikibooks-20241007-cirrussearch-content.json.gz \
    --output_file $DATA_DIR/wikibooks-tohoku-corpus.txt.gz \
    --min_sentence_length 10 \
    --max_sentence_length 1024 \
    --mecab_option '-r /etc/mecabrc -d /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd' #echo `mecab-config --dicdir`"/mecab-ipadic-neologd"
    python ../../externals/bert-japanese/merge_split_corpora.py \
    --input_files $DATA_DIR/wikibooks-tohoku-corpus.txt.gz \
    --output_dir $DATA_DIR/wikibooks \
    --num_files 8
    python ../../source/dataset/concat_sentence.py \
    --folder_path $DATA_DIR/wikibooks/\*.txt \
    --output_file $DATA_DIR/wikibooks/wikibooks.txt
    mv $DATA_DIR/wikibooks/wikibooks.txt ../../externals/corpus-cleaner/results/dataset/original/

    # ------------------------------------------
    #   Download wikibooks corpus
    # ------------------------------------------
    echo ">>> Download Wikiversity."
    #wget https://dumps.wikimedia.org/other/cirrussearch/20241007/jawikiversity-20241007-cirrussearch-content.json.gz -P $DATA_DIR
    mkdir -p $DATA_DIR/wikiversity
    python ../../externals/bert-japanese/make_corpus_wiki.py \
    --input_file $DATA_DIR/jawikiversity-20241007-cirrussearch-content.json.gz \
    --output_file $DATA_DIR/wikiversity-tohoku-corpus.txt.gz \
    --min_sentence_length 10 \
    --max_sentence_length 1024 \
    --mecab_option '-r /etc/mecabrc -d /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd' #echo `mecab-config --dicdir`"/mecab-ipadic-neologd"
    python ../../externals/bert-japanese/merge_split_corpora.py \
    --input_files $DATA_DIR/wikiversity-tohoku-corpus.txt.gz \
    --output_dir $DATA_DIR/wikiversity \
    --num_files 8
    python ../../source/dataset/concat_sentence.py \
    --folder_path $DATA_DIR/wikiversity/\*.txt \
    --output_file $DATA_DIR/wikiversity/wikiversity.txt

    mv $DATA_DIR/wikiversity/wikiversity.txt ../../externals/corpus-cleaner/results/dataset/original/

    # ------------------------------------------
    #   download and clean cc100 corpus
    # ------------------------------------------
    # download cc100
    echo ">>> Download japanese CC-100."
    wget http://data.statmt.org/cc-100/ja.txt.xz -P $DATA_DIR
    mkdir -p $DATA_DIR/cc100/
    python ../../externals/bert-japanese/merge_split_corpora.py \
    --input_files $DATA_DIR/ja.txt.xz \
    --output_dir $DATA_DIR/cc100/ \
    --num_files 64

    python ../../source/dataset/concat_sentence.py \
    --folder_path $DATA_DIR/cc100/\*.txt \
    --output_file $DATA_DIR/cc100/cc100.txt
    # rm "./results/dataset/cc100/corpus_${i}.txt"
    mv $DATA_DIR/cc100/cc100.txt ../../externals/corpus-cleaner/results/dataset/original/

    # ------------------------------------------
    #   download and split oscar2019 corpus
    # ------------------------------------------
    # reference
    # https://huggingface.co/datasets/oscar
    # https://huggingface.co/datasets/oscar/blob/main/oscar.py

    # download dataset
    mkdir -p results/dataset/oscar/original/

    for i in $(seq 1 120)
    do
       # refer:https://s3.amazonaws.com/datasets.huggingface.co/oscar/1.0/unshuffled/original/ja/ja_sha256.txt
       wget "https://s3.amazonaws.com/datasets.huggingface.co/oscar/1.0/unshuffled/original/ja/ja_part_${i}.txt.gz" -P "./results/dataset/oscar/"
       gunzip "./results/dataset/oscar/ja_part_${i}.txt.gz"
       # rm "./results/original/oscar/ja_part_${i}.txt.gz"
    done

    touch ./results/dataset/oscar/original/oscar2109_ja.txt
    merge files of dataset
    for i in $(seq 1 120)
    do
       cat "./results/dataset/oscar/ja_part_${i}.txt" >> ./results/dataset/oscar/original/oscar2109_ja.txt
       rm  "./results/dataset/oscar/ja_part_${i}.txt"
    done

    # rm -r "./results/original/oscar"

    train test split
    echo "# train test split oscar2109_ja.txt"
    LINES=`wc -l ./results/dataset/oscar/original/oscar2109_ja.txt | awk '{print $1}'`
    echo $LINES

    TRAIN_DATA_LINES=$(($LINES*90/100))
    REMAIN_DATA_LINES=$(($LINES-$TRAIN_DATA_LINES))
    # TEST_DATA_LINES=$((($LINES-$TRAIN_DATA_LINES)/2))
    # VALID_DATA_LINES=$(($LINES-$TRAIN_DATA_LINES) - $TEST_DATA_LINES)
    echo $TRAIN_DATA_LINES
    echo $REMAIN_DATA_LINES
    # echo $TEST_DATA_LINES

    head -n $TRAIN_DATA_LINES ./results/dataset/oscar/original/oscar2109_ja.txt > ./results/dataset/oscar/original/oscar2109_ja_train.txt
    tail -n $REMAIN_DATA_LINES ./results/dataset/oscar/original/oscar2109_ja.txt > ./results/dataset/oscar/original/oscar2109_ja_remain.txt

    TEST_DATA_LINES=$(($REMAIN_DATA_LINES/2))
    VALID_DATA_LINES=$(($REMAIN_DATA_LINES-$TEST_DATA_LINES))
    head -n $TEST_DATA_LINES ./results/dataset/oscar/original/oscar2109_ja_remain.txt > ./results/dataset/oscar/original/oscar2109_ja_test.txt
    tail -n $VALID_DATA_LINES ./results/dataset/oscar/original/oscar2109_ja_remain.txt > ./results/dataset/oscar/original/oscar2109_ja_valid.txt

    rm ./results/dataset/oscar/original/oscar2109_ja_remain.txt 
    rm ./results/dataset/oscar/original/oscar2109_ja.txt 

    # ------------------------------------------
    #   download mc4 corpus
    # ------------------------------------------
    # donwload mc4
    GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/datasets/allenai/c4.git
    cd c4/multilingual
    # Download 100 items from 0 to 99. 1.5GB each, total 150GB.
    for i in $(seq -w 0 100)
    do
    git lfs pull --include "c4-ja.tfrecord-00${i}-of-01024.json.gz"
    done
    #git lfs pull --include "c4-ja.*.json.gz"

    cd -

    mkdir -p ja
    #mv c4/multilingual/c4-ja.*.json.gz ja
    for i in $(seq -w 0 100)
    do
    mv c4/multilingual/c4-ja.tfrecord-00${i}-of-01024.json.gz ja
    gzip -d ja/c4-ja.tfrecord-00${i}-of-01024.json.gz
    done
    du -sh ja
    # 1.4T    ja
    ls -l ja | grep "^-" | wc -l
    # 70: count of files

    touch ja/c4-ja.txt
    # extract text of jsonl
    for i in $(seq -w 0 100)
    do 
    python ../../source/util/extract_text_of_jsonl.py \
        --input_path ./ja/c4-ja.tfrecord-00${i}-of-01024.json\
        --output_path ./ja/c4-ja-${i}.txt\

    #rm ja/c4-ja.tfrecord-00${i}-of-01024.json
    cat ./ja/c4-ja-${i}.txt >> ja/c4-ja.txt
    # rm ./ja/c4-ja-${i}.txt
    done 

    mv ./ja/c4-ja.txt ../../externals/corpus-cleaner/results/dataset/original
    # ------------------------------------------
    #   corpus_cleaner
    # ------------------------------------------
    # setup corpus_cleaner
    cd ../../externals/corpus-cleaner/
    git checkout v0.1.1
    # # bash scripts/setup.sh
    bash scripts/build.sh
    cd -

    # execute cleaning corpus
    cd ../../externals/corpus-cleaner/corpus_cleaner/build
    ICUPATH=$PWD/../../scripts/icu/usr/local
    echo $ICUPATH
    export C_INCLUDE_PATH=$ICUPATH/include
    export CPLUS_INCLUDE_PATH=$ICUPATH/include
    export LIBRARY_PATH=$ICUPATH/lib
    export LD_LIBRARY_PATH=$ICUPATH/lib

    ./corpus_cleaner
    cd -

    # ------------------------------------------
    #   create corpus
    # ------------------------------------------
    ### merge jsonl files ###
    cp ../../externals/corpus-cleaner/results/dataset/cleaned/wiki.jsonl ./results/dataset/train.jsonl
    cat ../../externals/corpus-cleaner/results/dataset/cleaned/wikibooks.jsonl >>./results/dataset/train.jsonl
    cat ../../externals/corpus-cleaner/results/dataset/cleaned/wikiversity.jsonl >>./results/dataset/train.jsonl
    cat ../../externals/corpus-cleaner/results/dataset/cleaned/cc100.jsonl >> ./results/dataset/train.jsonl
    cat ../../externals/corpus-cleaner/results/dataset/cleaned/oscar2109_ja_train.jsonl >> ./results/dataset/train.jsonl
    cat ../../externals/corpus-cleaner/results/dataset/cleaned/c4-ja.jsonl >> ./results/dataset/train.jsonl

    ### merge jsonl files for tokenizer ###
    mkdir -p ./results/preprocess/
    cp ../../externals/corpus-cleaner/results/dataset/cleaned/wiki.jsonl ./results/tokenizer/tokenizer_corpus.jsonl
    cat ../../externals/corpus-cleaner/results/dataset/cleaned/cc100.jsonl >> ./results/tokenizer/tokenizer_corpus.jsonl

    mv ../../externals/corpus-cleaner/results/dataset/cleaned/oscar2109_ja_valid.jsonl ./results/dataset/
    mv ../../externals/corpus-cleaner/results/dataset/cleaned/oscar2109_ja_test.jsonl ./results/dataset/

    # split dataset for pretrain
    python ../../source/dataset/split_dataset.py \
        --input_file ./results/dataset/train.jsonl \
        --split_ratio 0.8
        # --input_file ../../source/dataset/wiki.jsonl \

    ### remove directory ###
    # for dataset_type in "oscar" "wiki" "cc100"
    # do
    # rm -r ./externals/corpus-cleaner/results/data/$dataset_type/cleaned/ 
    # done

else
    # download mistral-300m-corpus from huggingface
    echo "false"
fi

