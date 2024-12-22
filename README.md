# mistral-2b-recipe

[![Apache-2.0](https://custom-icon-badges.herokuapp.com/badge/license-Apache%202.0-8BB80A.svg?logo=law&logoColor=white)](LICENSE)
[![Python](https://custom-icon-badges.herokuapp.com/badge/Python-3572A5.svg?logo=Python&logoColor=white)]()
![Linux](https://custom-icon-badges.herokuapp.com/badge/Linux-F6CE18.svg?logo=Linux&logoColor=white)  
[![Zenn](https://img.shields.io/badge/--FFFFFF?style=social&logo=zenn&label=zenn)](https://zenn.dev/selllous)
[![Twitter](https://img.shields.io/badge/--FFFFFF?style=social&logo=twitter&label=twitter)](https://twitter.com/ce__lery)

## Overview

Welcome to my repository!   
This repository is the recipe for create [ce-lery/mistral-2b-base](https://huggingface.co/ce-lery/mistral-2b-base).

The feature is ...

- Trained by japanese
- Trained in two stages: patch level and token level
- Suppression of unknown word generation by using byte fallback in SentencePiece tokenizer and conversion to huggingface Tokenizers format
- Use of Mistral 2B

Yukkuri shite ittene!

## Getting Started

Clone this repository.

```bash
git clone https://github.com/ce-lery/mistral-2b-recipe.git --recursive
cd mistral-2b-recipe
```

Build a Python environment using Docker files.

```bash 
docker-compose build
docker-compose run mistral2b
```

Run the shell script with the following command.  
Execute python virtual environment construction, corpus cleaning, and pretrain in order.  

```bash
cd examples/pretrain_mistral_2b

# install tools
bash setup.sh
# download dataset & cleaning
bash dataset.sh
# training tokenizer & convert huggingface format
bash tokenizer.sh
# pretrain corpus
bash pretrain_patch.sh
# inference
bash inference.sh
```

## User Guide

The User Guide for this repository is published [here](https://zenn.dev/selllous/articles/transformers_pretrain_to_ft2).  
It is written in Japanese  


<!-- ## Getting Started

```bash
docker build -t mistral-300m-image ./
docker run -v $PWD/:/home/mistral-300m/ -it --gpus all mistral-300m-image
```


```bash
# docker build -t mistral-300m-image ./
docker run -v $PWD/:/home/mistral-300m/ --gpus all -it -d --name=te-mistral- nvcr.io/nvidia/pytorch:24.04-py3
```
 -->
