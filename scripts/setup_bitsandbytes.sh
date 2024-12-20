#! /bin/bash
# refer:https://huggingface.co/docs/bitsandbytes/main/en/installation
mkdir -p externals
cd externals
git clone https://github.com/bitsandbytes-foundation/bitsandbytes.git && cd bitsandbytes/
pip install -r requirements-dev.txt
cmake -DCOMPUTE_BACKEND=cuda -S .
make
pip install -e .   # `-e` for "editable" install, when developing BNB (otherwise leave that out)