BATCH_SIZE=64
GRADIENT_ACCUMULATION_STEPS=4
EPOCH=1
DIR_NAME=patch_pretrain_falcon_1b
mkdir -p ~/falcon3/results/pretrain/

accelerate launch ../source/train/run_clm_patch.py \
    --model_type "llama" \
    --model_name_or_path tiiuae/Falcon3-1B-Base \
    --dataset_name kajuma/training_12-23_patch \
    --patch_size 4 \
    --output_dir ~/falcon3/results/$DIR_NAME/trial1 \
    --cache_dir ~/falcon3/results/cache/patch_train \
    --do_train \
    --do_eval \
    --prediction_loss_only \
    --remove_unused_columns False \
    --learning_rate 2.0e-4 \
    --weight_decay 0.1 \
    --num_train_epochs $EPOCH \
    --logging_dir ~/falcon3/results/logs/$DIR_NAME/trial1 \
    --logging_strategy "steps" \
    --logging_steps 1 \
    --save_strategy "steps" \
    --save_steps 100 \
    --eval_steps 500 \
    --save_total_limit 1000000 \
    --lr_scheduler_type constant \
    --per_device_train_batch_size $BATCH_SIZE \
    --per_device_eval_batch_size $BATCH_SIZE \
    --low_cpu_mem_usage \
    --block_size 2048 \
    --torch_dtype "bfloat16" \
    --gradient_accumulation_steps $GRADIENT_ACCUMULATION_STEPS \
    --push_to_hub False \
    --preprocessing_num_workers 64 \
    --dataloader_num_workers 64 \
    --optim "schedule_free_adamw" \
    --attn_implementation "flash_attention_2" \
    # --resume_from_checkpoint ~/checkpoint-5000/
    # --torch_compile True \
    # --torch_compile_backend "eager" \
    # --resume_from_checkpoint ./results/pretrain/pretrain_mistral/trial1/checkpoint-5000/
    # --gradient_checkpointing True 
    # --min_lr 8.0e-6 \
    #--load_best_model_at_end \