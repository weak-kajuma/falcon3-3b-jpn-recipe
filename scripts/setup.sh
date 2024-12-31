#! /bin/bash

pip install transformers==4.46.3
pip install sentencepiece datasets evaluate accelerate==1.2.1
pip install scikit-learn
pip install bitsandbytes
pip install liger_kernel
pip install schedulefree
pip install wheel
pip install flash-attn --no-build-isolation
pip install git+https://github.com/NVIDIA/TransformerEngine.git@stable
