#! /bin/bash

# Please run the command "cd examples/pretrain_mistral_3b/ ; bash setup.sh"

# set log
mkdir -p results/log/$(basename "$0" .sh)
log=results/log/$(basename "$0" .sh)/$(date +%Y%m%d_%H%M%S).log
exec &> >(tee -a $log)
set -x

apt-get install mecab mecab-ipadic-utf8 libmecab-dev swig  -y
# mv /etc/mecabrc /usr/local/etc/

### install mecab-ipadic-neologd (for wikipedia-tohoku)
cd ../../externals/mecab-ipadic-neologd
echo yes | ./bin/install-mecab-ipadic-neologd -n -u