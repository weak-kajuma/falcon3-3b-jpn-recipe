from datasets import load_dataset

data_files={}
data_files["train"]="./cache/resampled_cache/8.jsonl"
#data_files["train"]="./results/dataset/cc100/cc100.txt"
ds = load_dataset(
    "json",
    data_files = data_files,
    cache_dir="./cache/oscar/",
    split="train",
)

print(ds["text"][0])