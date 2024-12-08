#! /bin/bash

# set log
mkdir -p results/log/$(basename "$0" .sh)
log=results/log/$(basename "$0" .sh)/$(date +%Y%m%d_%H%M%S).log
exec &> >(tee -a $log)
set -x

# set parameters
export TOKENIZERS_PARALLELISM=false
#refer: https://zenn.dev/bilzard/scraps/5b00b74984831f
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True

BATCH_SIZE=4
GRADIENT_ACCUMULATION_STEPS=64
EPOCH=1
DIR_NAME=patch_pretrain_mistral_2b
mkdir -p ./results/patch_train/

# intialize process counter
SECONDS=0

# ------------------------------------------
#   1st: patch train
# ------------------------------------------
#rm -r ./results/pretrain/$DIR_NAME/mistral2b_trial2
python ../../source/train/run_clm_patch.py \
    --model_type "mistral" \
    --config_name ../../source/model/config/config_mistral_2b.json \
    --tokenizer_name ./results/tokenizer/llamatokenizer \
    --train_file ./results/dataset/train_head.jsonl \
    --patch_size 4 \
    --output_dir ./results/pretrain/$DIR_NAME/trial1 \
    --cache_dir ./results/pretrain/cache/patch_train \
    --do_train \
    --prediction_loss_only \
    --remove_unused_columns False \
    --learning_rate 2.0e-4 \
    --weight_decay 0.1 \
    --adam_beta2 0.95 \
    --num_train_epochs $EPOCH \
    --logging_dir ./results/pretrain/logs/$DIR_NAME/trial1 \
    --logging_strategy "steps" \
    --logging_steps 10 \
    --save_strategy "steps" \
    --save_steps 1000 \
    --save_total_limit 3 \
    --warmup_steps 1000 \
    --min_lr_rate 0.1 \
    --lr_scheduler_type cosine_with_min_lr \
    --per_device_train_batch_size $BATCH_SIZE \
    --per_device_eval_batch_size $BATCH_SIZE \
    --block_size 1024 \
    --adam_epsilon 1.0e-8 \
    --torch_dtype "bfloat16" \
    --gradient_accumulation_steps $GRADIENT_ACCUMULATION_STEPS \
    --push_to_hub False\
    --preprocessing_num_workers 8 \
    --dataloader_num_workers 8 \
    --optim "adamw_bnb_8bit" \
#    --torch_compile True \
#    --torch_compile_backend "eager" \
    # --resume_from_checkpoint ./results/pretrain/pretrain_mistral/trial1/checkpoint-5000/
    # --gradient_checkpointing True 
    # --min_lr 8.0e-6 \
    #--load_best_model_at_end \

BATCH_SIZE=2
GRADIENT_ACCUMULATION_STEPS=128

# ------------------------------------------
#  2nd: pretrain
# ------------------------------------------
python ../../source/train/run_clm_patch.py \
    --model_type "mistral" \
    --model_name_or_path ./results/pretrain/$DIR_NAME/trial1\
    --train_file ./results/dataset/train_tail.jsonl \
    --patch_size 1 \
    --output_dir ./results/pretrain/$DIR_NAME/trial2 \
    --cache_dir ./results/pretrain/cache/patch_train \
    --do_train \
    --prediction_loss_only \
    --remove_unused_columns False \
    --learning_rate 2.0e-4 \
    --weight_decay 0.1 \
    --adam_beta2 0.95 \
    --num_train_epochs $EPOCH \
    --logging_dir ./results/pretrain/logs/$DIR_NAME/trial2 \
    --logging_strategy "steps" \
    --logging_steps 10 \
    --save_strategy "steps" \
    --save_steps 1000 \
    --save_total_limit 3 \
    --warmup_steps 1000 \
    --min_lr_rate 0.1 \
    --lr_scheduler_type cosine_with_min_lr \
    --per_device_train_batch_size $BATCH_SIZE \
    --per_device_eval_batch_size $BATCH_SIZE \
    --block_size 1024 \
    --adam_epsilon 1.0e-8 \
    --torch_dtype "bfloat16" \
    --gradient_accumulation_steps $GRADIENT_ACCUMULATION_STEPS \
    --push_to_hub False\
    --preprocessing_num_workers 8 \
    --dataloader_num_workers 8 \
    --optim "adamw_bnb_8bit" \
    # --torch_compile True \
    # --torch_compile_backend "eager" \
    # --resume_from_checkpoint ./results/pretrain/pretrain_mistral/trial1/checkpoint-5000/
    # --gradient_checkpointing True 
    # --min_lr 8.0e-6 \
    #--load_best_model_at_end \

time=$SECONDS
echo "process_time: $time sec"


set +x