BATCH_SIZE=16
GRADIENT_ACCUMULATION_STEPS=16
EPOCH=1
DIR_NAME=patch_pretrain_falcon_1b
mkdir -p ~/falcon3-token/results/

python ../source/train/run_clm.py \
    --model_type "llama" \
    --model_name_or_path kajuma/falcon3_1b_patch \
    --dataset_name kajuma/training_12-23_token \
    --output_dir ~/falcon3-token/results/ \
    --cache_dir ./cache/ \
    --do_train \
    --do_eval \
    --prediction_loss_only \
    --remove_unused_columns False \
    --learning_rate 2.0e-4 \
    --weight_decay 0.1 \
    --num_train_epochs $EPOCH \
    --logging_dir ~/falcon3-token/results/logs/ \
    --logging_strategy "steps" \
    --logging_steps 1 \
    --save_strategy "steps" \
    --eval_strategy "steps" \
    --save_steps 100 \
    --eval_steps 500 \
    --save_total_limit 100000 \
    --lr_scheduler_type constant \
    --per_device_train_batch_size $BATCH_SIZE \
    --per_device_eval_batch_size $BATCH_SIZE \
    --low_cpu_mem_usage \
    --block_size 2048 \
    --torch_dtype "bfloat16" \
    --gradient_accumulation_steps $GRADIENT_ACCUMULATION_STEPS \
    --push_to_hub True \
    --hub_strategy end \
    --preprocessing_num_workers 64 \
    --dataloader_num_workers 64 \
    --optim "schedule_free_radam" \
    --attn_implementation "flash_attention_2" \
    --use_liger_kernel True \
    --overwrite_output_dir
    # --torch_compile True \
    # --torch_compile_backend "eager" \
    # --resume_from_checkpoint ./results/pretrain/pretrain_mistral/trial1/checkpoint-5000/
    # --gradient_checkpointing True 
    # --min_lr 8.0e-6 \
    #--load_best_model_at_end \