#! /bin/bash

# cd 

# make & activate venv
if [ -d ".env_llm_jp_eval" ];then
    echo "Already exist .env"
    exit 1
fi

# create python virtual environment

# install python library
# pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
# pip install -r requirements.txt

# ------------------------------------------
#   setup llm-jp-eval
# ------------------------------------------
# mkdir -p ./results/log
# python -m venv .env_llm_jp_eval
# source .env_llm_jp_eval/bin/activate
# ./python -m pip install --upgrade pip

# # install llm-jp-eval
# git clone -b v1.4.1 https://github.com/llm-jp/llm-jp-eval.git
# cd llm-jp-eval
# pip install .

# pip install transformers==4.44.2

# # copy configuration file
# cp ../../../source/eval/config-2b.yaml ./configs/
# # cp ../config-300m.yaml ./configs/

# # download evaluation dataset
# python scripts/preprocess_dataset.py  \
#   --dataset-name all  \
#   --output-dir eval_dataset \
#   --version-name dataset_version_name \

# cd ../

#deactivate
# ------------------------------------------
#   setup lm-evaluation-harness
# ------------------------------------------
python -m venv .env_lm_evaluation_harness
source .env_lm_evaluation_harness/bin/activate
./python -m pip install --upgrade pip

# # install
# git clone -b jp-stable https://github.com/Stability-AI/lm-evaluation-harness.git
cd lm-evaluation-harness
pip install -e ".[ja]"
pip install datasets==2.0.0


# sh harness.sh

cd -

deactivate

