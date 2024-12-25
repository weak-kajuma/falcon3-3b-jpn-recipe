BATCH_SIZE=8
GRADIENT_ACCUMULATION_STEPS=32
EPOCH=1
DIR_NAME=patch_pretrain_falcon_3b
mkdir -p ~/results/pretrain/

python ../source/train/run_clm_patch.py \
    --model_type "llama" \
    --model_name_or_path tiiuae/Falcon3-3B-Base \
    --dataset_name kajuma/training_12-23_patch \
    --patch_size 4 \
    --output_dir ~/results/pretrain/$DIR_NAME/trial1 \
    --cache_dir ~/results/pretrain/cache/patch_train \
    --do_train \
    --do_eval \
    --prediction_loss_only \
    --remove_unused_columns False \
    --learning_rate 2.0e-4 \
    --weight_decay 0.1 \
    --adam_beta2 0.95 \
    --num_train_epochs $EPOCH \
    --logging_dir ~/results/pretrain/logs/$DIR_NAME/trial1 \
    --logging_strategy "steps" \
    --logging_steps 10 \
    --save_strategy "steps" \
    --save_steps 100 \
    --eval_steps 500 \
    --save_total_limit 3 \
    --warmup_steps 1000 \
    --min_lr_rate 0.1 \
    --lr_scheduler_type cosine_with_min_lr \
    --per_device_train_batch_size $BATCH_SIZE \
    --per_device_eval_batch_size $BATCH_SIZE \
    --low_cpu_mem_usage \
    --block_size 2048 \
    --adam_epsilon 1.0e-8 \
    --torch_dtype "bfloat16" \
    --gradient_accumulation_steps $GRADIENT_ACCUMULATION_STEPS \
    --push_to_hub True \
    --preprocessing_num_workers 64 \
    --dataloader_num_workers 64 \
    --optim "adamw_bnb_8bit" \
    --attn_implementation "flash_attention_2" \
    --resume_from_checkpoint ~/checkpoint-5000/
    # --torch_compile True \
    # --torch_compile_backend "eager" \
    # --resume_from_checkpoint ./results/pretrain/pretrain_mistral/trial1/checkpoint-5000/
    # --gradient_checkpointing True 
    # --min_lr 8.0e-6 \
    #--load_best_model_at_end \