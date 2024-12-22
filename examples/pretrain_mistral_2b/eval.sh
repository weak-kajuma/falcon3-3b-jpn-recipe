#! /bin/bash

# source .env_llm_jp_eval/bin/activate

# # python ./llm-jp-eval/scripts/evaluate_llm.py -cn config-2b.yaml 

# python ./llm-jp-eval/scripts/evaluate_llm.py -cn config-2b.yaml \
# model.pretrained_model_name_or_path=./results/pretrain/patch_pretrain_mistral_2b/trial2/ \
# tokenizer.pretrained_model_name_or_path=./results/pretrain/patch_pretrain_mistral_2b/trial2/ 

# # python ./llm-jp-eval/scripts/evaluate_llm.py -cn config-300m.yaml \
# # model.pretrained_model_name_or_path="ce-lery/japanese-mistral-300m-base" \
# # tokenizer.pretrained_model_name_or_path="ce-lery/japanese-mistral-300m-base"

# deactivate

source .env_lm_evaluation_harness/bin/activate

mkdir -p ./results/eval/archive

# refs:https://github.com/Stability-AI/lm-evaluation-harness/blob/jp-stable/models/rinna/rinna-japanese-gpt-neox-small/harness.sh
# define macro
TASK="jsquad-1.1-0.6,jcommonsenseqa-1.1-0.6,jnli-1.3-0.6,marc_ja-1.1-0.6,jaqket_v2-0.2-0.2"
NUM_FEWSHOT="2,3,3,3,1"

# model list
declare -A models
models=(
    ["mistral-2b"]="./results/pretrain/patch_pretrain_mistral_2b/trial2/"
    ["japanese-gpt-neox-small"]="rinna/japanese-gpt-neox-small"
    # ["open-calm-3b"]="cyberagent/open-calm-3b"
    ["rinna-japanese-gpt-1b"]="rinna/japanese-gpt-1b"
    ["rinna-japanese-gpt-neox-3.6b"]="rinna/japanese-gpt-neox-3.6b"
)

for model_name in "${!models[@]}"; do
    echo "Evaluating ${model_name}..."
    
    # get path
    model_path="${models[$model_name]}"
    
    # MODEL_ARGSを設定
    MODEL_ARGS="pretrained=${model_path},use_fast=False"
    
    # evaluation
    python lm-evaluation-harness/main.py \
        --model hf-causal \
        --model_args "$MODEL_ARGS" \
        --tasks "$TASK" \
        --num_fewshot "$NUM_FEWSHOT" \
        --device "cuda" \
        --output_path "results/eval/result-${model_name}.json"
    
    # copy results
    cp "./results/eval/result-${model_name}.json" results/eval/archive
    
    echo "Completed evaluation of ${model_name}"
done


deactivate

# TASK="jcommonsenseqa-1.1-0.2,jnli-1.3-0.6,marc_ja-1.1-0.2,jsquad-1.1-0.2,jaqket_v2-0.2-0.2,mgsm-1.0-0.6"
# python lm-evaluation-harness/main.py \
#     --model hf-causal \
#     --model_args $MODEL_ARGS \
#     --tasks $TASK \
#     --num_fewshot "3,3,3,2,1,5" \
#     --device "cuda" \
#     --output_path "results/eval/result-mistral-2b.json"