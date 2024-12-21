#! /bin/bash

# Please run the command "cd examples/pretrain_mistral_3b/ ; bash dataset.sh true"

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
    
    # download wiki
    echo ">>> Download Wikipedia."
    # wget https://dumps.wikimedia.org/other/cirrussearch/20241007/jawiki-20241007-cirrussearch-content.json.gz -P $DATA_DIR
    #TODO: upload jawiki's json.gz to huggingface
    #GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/datasets/ce-lery/dataset_archive.git $DATA_DIR/dataset_archive
    #cd $DATA_DIR/dataset_archive
    #git lfs pull 
    #mv ./jawiki-20241007-cirrussearch-content.json.gz ../ 
    #cd -
    #rm -r $DATA_DIR/dataset_archive

    #mkdir -p $DATA_DIR/wikipedia
    #python ../../externals/bert-japanese/make_corpus_wiki.py \
    #--input_file $DATA_DIR/jawiki-20241007-cirrussearch-content.json.gz \
    #--output_file $DATA_DIR/wiki-tohoku-corpus.txt.gz \
    #--min_sentence_length 10 \
    #--max_sentence_length 200 \
    #--mecab_option '-r /etc/mecabrc -d /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd' #echo `mecab-config --dicdir`"/mecab-ipadic-neologd"
    #python ../../externals/bert-japanese/merge_split_corpora.py \
    #--input_files $DATA_DIR/wiki-tohoku-corpus.txt.gz \
    #--output_dir $DATA_DIR/wikipedia \
    #--num_files 8
    #python ../../source/dataset/concat_sentence.py \
    #--folder_path $DATA_DIR/wikipedia/\*.txt \
    #--output_file $DATA_DIR/wikipedia/wiki.txt

    # # download wikibooks
    # echo ">>> Download WikiBooks."
    # wget https://dumps.wikimedia.org/other/cirrussearch/20241007/jawikibooks-20241007-cirrussearch-content.json.gz -P $DATA_DIR
    # mkdir -p $DATA_DIR/wikibooks
    # python ../../externals/bert-japanese/make_corpus_wiki.py \
    # --input_file $DATA_DIR/jawikibooks-20241007-cirrussearch-content.json.gz \
    # --output_file $DATA_DIR/wikibooks-tohoku-corpus.txt.gz \
    # --min_sentence_length 10 \
    # --max_sentence_length 1024 \
    # --mecab_option '-r /etc/mecabrc -d /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd' #echo `mecab-config --dicdir`"/mecab-ipadic-neologd"
    # python ../../externals/bert-japanese/merge_split_corpora.py \
    # --input_files $DATA_DIR/wikibooks-tohoku-corpus.txt.gz \
    # --output_dir $DATA_DIR/wikibooks \
    # --num_files 8

    # # download cc100
    # echo ">>> Download japanese CC-100."
    # wget http://data.statmt.org/cc-100/ja.txt.xz -P $DATA_DIR
    # mkdir -p $DATA_DIR/corpus/cc-100
    # python ../../externals/bert-japanesemerge_split_corpora.py \
    # --input_files $DATA_DIR/ja.txt.xz \
    # --output_dir $DATA_DIR/corpus/cc-100 \
    # --num_files 64

    ### corpus cleaning
    cd ../../externals/corpus-cleaner/
    # # bash scripts/setup.sh
    bash scripts/build.sh
    cd -

    mkdir -p ./results/dataset/wikipedia/original/
    cp ./results/dataset/wikipedia/wiki.txt ./results/dataset/wikipedia/original/

    cd ../../externals/corpus-cleaner/corpus_cleaner/build
    ICUPATH=$PWD/../../scripts/icu/usr/local
    echo $ICUPATH
    export C_INCLUDE_PATH=$ICUPATH/include
    export CPLUS_INCLUDE_PATH=$ICUPATH/include
    export LIBRARY_PATH=$ICUPATH/lib
    export LD_LIBRARY_PATH=$ICUPATH/lib

    ./corpus_cleaner ./../../../../examples/pretrain_mistral_3b/config_wiki.json



    ### merge jsonl files ###
    # for split in "train" "test" "valid"
    # do
    # mv ./externals/corpus-cleaner/results/data/oscar/cleaned/oscar2109_ja_$split.jsonl ./results/dataset/$split.jsonl
    # cat ./externals/corpus-cleaner/results/data/cc100/cleaned/cc100_$split.jsonl >> ./results/dataset/$split.jsonl
    # cat ./externals/corpus-cleaner/results/data/wiki/cleaned/wiki_$split.jsonl >> ./results/dataset/$split.jsonl
    # #echo $split
    # done


    ### remove directory ###
    # for dataset_type in "oscar" "wiki" "cc100"
    # do
    # rm -r ./externals/corpus-cleaner/results/data/$dataset_type/cleaned/ 
    # done

else
    # download mistral-300m-corpus from huggingface
    echo "false"
fi
