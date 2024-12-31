#! /bin/bash


pip install git+https://github.com/nhamanasu/transformers.git@radam-schedulefree
pip install sentencepiece datasets evaluate accelerate==1.2.1
pip install scikit-learn
pip install bitsandbytes
pip install liger_kernel
pip install schedulefree
pip install wheel
pip install flash-attn --no-build-isolation
pip install tf-keras
# pip install git+https://github.com/NVIDIA/TransformerEngine.git@stable
pip install transformer_engine[pytorch]


huggingface-cli login --token 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
pip install hf_transfer wandb
HF_HUB_ENABLE_HF_TRANSFER=1 huggingface-cli download kajuma/falcon3_3b_patch
HF_HUB_ENABLE_HF_TRANSFER=1 huggingface-cli download kajuma/training_12-23_token --repo-type dataset
wandb login b14b6a1a8365f6713ff33a8b4aa7753f50ca572f