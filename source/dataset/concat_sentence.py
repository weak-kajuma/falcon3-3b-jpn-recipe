import os
import glob
import argparse
from argparse import Namespace

import os
import glob

def concat_sentence(folder_path:str,remove_input_file=True):
    """Merge sentences for all files in a folder with empty delimiters
    For example, for the following file,
      aa
      bb
      <empty line>
      cc
      dd
    The results are as follows.
      aabb
      ccdd
    """

    for file_path in glob.glob(folder_path):
        if not os.path.isfile(file_path):
            continue

        print(f"Start Processed file: {file_path}")
        output_filename = f"merged_{os.path.basename(file_path)}"
        output_path = os.path.join(os.path.dirname(file_path), output_filename)

        with open(file_path, 'r', encoding='utf-8', errors='ignore') as input_file, \
            open(output_path, 'w', encoding='utf-8') as output_file:

            current_paragraph = []

            for line in input_file:
                line = line.strip()
                if line:
                    current_paragraph.append(line)
                else:
                    if current_paragraph:
                        merged_line = ''.join(current_paragraph)
                        output_file.write(merged_line + '\n')
                        current_paragraph = []

            # process line of the end of file
            if current_paragraph:
                merged_line = ''.join(current_paragraph)
                output_file.write(merged_line)

        print(f"Merged content saved to: {output_filename}")

        if remove_input_file:
           os.remove(file_path)


def concatenate_files(folder_path, output_file, remove_input_file=False):
    # sort file list
    files = sorted(glob.glob(folder_path))

    with open(output_file, 'w', encoding='utf-8') as outfile:
        for i,file_path in enumerate(files):
            if not os.path.isfile(file_path):
                continue
            print(f"Concatenating: {file_path}")
            # load each file, and write outputfile
            with open(file_path, 'r', encoding='utf-8') as infile:
                outfile.write(infile.read())

            if i!=len(files)-1:
                outfile.write('\n')

            if remove_input_file:
                os.remove(file_path)

    print(f"All files have been concatenated into: {output_file}")

if __name__ == "__main__": 
    parser = argparse.ArgumentParser(description="")
    parser.add_argument("--folder_path",help="",default="./*.txt")    
    parser.add_argument("--output_file",help="",default="./output.txt")

    args = parser.parse_args()
    concat_sentence(folder_path=args.folder_path)
    concatenate_files(folder_path=args.folder_path, output_file=args.output_file)
    
