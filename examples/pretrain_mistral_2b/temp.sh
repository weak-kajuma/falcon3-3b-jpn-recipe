# donwload mc4
# size: 1.4TB

cd examples/pretrain_mistral_3b/

#GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/datasets/allenai/c4.git
cd c4/multilingual
#Download 100 items from #0 to 99. 1.5GB each, total 150GB.
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
