from datasets import load_dataset

data_files={}
data_files["train"]="./resampled/resampled_cache/4.jsonl"
#data_files["train"]="./results/dataset/cc100/cc100.txt"
ds = load_dataset(
    "json",
    data_files = data_files,
    cache_dir="./cache/cc100/",
    split="train",
)

print(ds["text"][0])