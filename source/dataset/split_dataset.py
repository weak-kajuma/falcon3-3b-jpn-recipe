import json
import os
import time
import argparse
from typing import Optional

def format_time(seconds: float) -> str:
    """Convert seconds to easy-to-read format"""
    if seconds < 60:
        return f"{seconds:.1f} sec"
    elif seconds < 3600:
        minutes = seconds / 60
        return f"{minutes:.1f} min"
    else:
        hours = seconds / 3600
        return f"{hours:.1f} h"

def split_jsonl_file(dataset_path: str, split_ratio: float, head_path: Optional[str] = None, tail_path: Optional[str] = None) -> Optional[tuple[str, str]]:
    """
    Split a JSONL file into two files based on number of characters.
    Displays progress and estimated remaining time.

    Args:
        dataset_path (str):  Input JSONL file path
        split_ratio (float): Split ratio (0.0 < split_ratio < 1.0)

    Returns:
        Optional[tuple[str, str]]: A tuple of output file paths on success, None on failure.
    """
    if not dataset_path.endswith('.jsonl'):
        print(f"Error: Input file must be a JSONL file, but got {dataset_path}")
        return None

    if not os.path.exists(dataset_path):
        print(f"Error: File not found: {dataset_path}")
        return None

    print("\nCounting total line number ...")
    try:
        print("\nCounting total line number ...")
        # get total line number of file
        with open(dataset_path, 'r', encoding='utf-8') as f:
            total_lines = sum(1 for _ in f)

        print(f"total line number of file: {total_lines:,}")
        print("\n1st pass: Counting total number of characters...")

        # 1st pass: Counting total number of characters
        total_chars = 0
        processed_lines = 0
        start_time = time.time()
        progress_interval = max(1, total_lines // 100) 

        with open(dataset_path, 'r', encoding='utf-8') as f:
            for line in f:
                try:
                    data = json.loads(line.strip())
                    if "text" in data:
                        total_chars += len(data["text"])
                    processed_lines += 1
                    
                    # display progress bar
                    if processed_lines % progress_interval == 0:
                        progress = (processed_lines / total_lines) * 100
                        print(f"\processed: {processed_lines:,}/{total_lines:,}line ({progress:.1f}%)", 
                              end='', flush=True)
                
                except json.JSONDecodeError:
                    print(f"\nWarning: Invalid JSON line: {line.strip()}")
                    continue

        print(f"\n1st pass completed. total characters: {total_chars:,}")

        # Calculate target word count
        target_chars = int(total_chars * split_ratio)

        # Generate output file name
        base_dir = os.path.dirname(dataset_path)
        if head_path is None:
            head_path = os.path.join(base_dir, 'train_head.jsonl')
        if tail_path is None:
            tail_path = os.path.join(base_dir, 'train_tail.jsonl')

        print("\n2nd pass: splitting files...")

        # 2nd pass: Split files and export
        current_chars = 0
        processed_lines = 0
        start_time_second_pass = time.time()
        head_file = open(head_path, 'w', encoding='utf-8')
        tail_file = open(tail_path, 'w', encoding='utf-8')

        try:
            with open(dataset_path, 'r', encoding='utf-8') as f:
                for line in f:
                    try:
                        data = json.loads(line.strip())
                        if "text" not in data:
                            print(f"\nWarning: 'text' key not found in line: {line.strip()}")
                            continue

                        chars = len(data["text"])
                        if current_chars < target_chars:
                            head_file.write(line)
                        else:
                            tail_file.write(line)
                        
                        current_chars += chars
                        processed_lines += 1

                        # Displays progress and estimated remaining time (in 1% increments)
                        if processed_lines % progress_interval == 0:
                            progress = (processed_lines / total_lines) * 100
                            elapsed_time = time.time() - start_time_second_pass
                            estimated_total_time = elapsed_time / (processed_lines / total_lines)
                            remaining_time = estimated_total_time - elapsed_time
                            
                            print(f"\processed: {processed_lines:,}/{total_lines:,}line ({progress:.1f}%) "
                                  f"Estimated remaining time: {format_time(remaining_time)}", end='', flush=True)

                    except json.JSONDecodeError:
                        print(f"\nWarning: Invalid JSON line: {line.strip()}")
                        continue

        finally:
            head_file.close()
            tail_file.close()

        total_time = time.time() - start_time
        print(f"\n\completed:")
        print(f"- Head file ({split_ratio:.1%}): {head_path}")
        print(f"- Tail file ({(1-split_ratio):.1%}): {tail_path}")
        print(f"total characters: {total_chars:,}")
        print(f"split place: {target_chars:,}")
        print(f"total elapsed time: {format_time(total_time)}")

        return head_path, tail_path

    except Exception as e:
        print(f"\nError occurred while processing the file: {str(e)}")
        return None

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Split a JSONL file into two files based on number of characters.',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''
        Usage example:
        # Basic usage (split 70:30)
        python script.py --input_file input.jsonl --split_ratio 0.7

        # specify output file name
        python script.py --input_file input.jsonl --split_ratio 0.7 --head output1.jsonl --tail output2.jsonl
        '''
    )
    
    parser.add_argument('--input_file',  help='input jsonl file path',default="./source/dataset/wiki.jsonl")
    parser.add_argument('--split_ratio', type=float, help='split ratio (0.0 < ratio < 1.0)',default=0.8)
    parser.add_argument('--head', help='Output path of the first half after division (default: train_head.jsonl)')
    parser.add_argument('--tail', help='Output path of the second half after division (default: train_tail.jsonl)')

    args = parser.parse_args()
    split_jsonl_file(args.input_file, args.split_ratio, args.head, args.tail)