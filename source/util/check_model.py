from transformers import AutoModelForCausalLM, AutoConfig
import argparse
from argparse import Namespace

def check_model_size(config_name):
    config = AutoConfig.from_pretrained(config_name)
    print(config)

    model = AutoModelForCausalLM.from_config(config)
    print(model)

    model_size = sum(t.numel() for t in model.parameters())
    print(f"model size: {model_size/2**20:.2f}M params")

def print_state_dict_keys(state_dict):
    for key in state_dict.keys():
        print(key)

if __name__ == "__main__": 
    parser = argparse.ArgumentParser(description="")
    parser.add_argument("--config_name",help="",default="./source/model/config/config_mistral_2b.json")
    # parser.add_argument("--output_path",help="",default="")
    
    args = parser.parse_args()
    check_model_size(args.config_name)

