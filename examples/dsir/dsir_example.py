from data_selection import HashedNgramDSIR
from datasets import load_dataset

raw_datasets = ["./results/dataset/cc100/cc100.txt"]
target_datasets = ["./wiki.txt"]

def load_dataset_fn(dataset_path):

    extension = dataset_path.split(".")[-1]
    if extension == "txt":
        extension = "text"
    elif extension == "jsonl":
        extension = "json"
    elif extension != csv and extension != json:
        extension = None

    data_files={}
    data_files["train"] = dataset_path
    ds = load_dataset(
        extension,
        data_files=data_files,
        #path=dataset_path,
        streaming=True, 
        cache_dir="./cache/dataset",
        split="train")
    return ds

def parse_example_fn(example):
    return example['text']

dsir = HashedNgramDSIR(raw_datasets, target_datasets, cache_dir='./cache/dsir_cache')

dsir = HashedNgramDSIR(
        raw_datasets=raw_datasets,
        target_datasets=target_datasets,
        cache_dir='./cache/dsir_cache',
        raw_parse_example_fn=parse_example_fn,
        raw_load_dataset_fn=load_dataset_fn,
        target_parse_example_fn=parse_example_fn,
        target_load_dataset_fn=load_dataset_fn,
        separate_targets=True)

dsir.fit_importance_estimator(num_tokens_to_fit='auto')
dsir.compute_importance_weights()
dsir.resample(out_dir='resampled', num_to_sample=10, cache_dir='./cache/resampled_cache')

"""
dsir.save('/path/to/dsir_params.pkl')

# later on
dsir.load('/path/to/dsir_params.pkl')
dsir.resample(out_dir='/path/to/out_dir', num_to_sample=100000000, cache_dir='/path/to/resampled_cache')
"""