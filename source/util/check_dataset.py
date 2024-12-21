import json

def find_null_text_lines(file_path):
    null_lines = []
    with open(file_path, 'r', encoding='utf-8') as file:
        for line_number, line in enumerate(file, start=1):
            print(f"処理中: 行 {line_number}", end='\r')  # 現在の行数を表示
            try:
                data = json.loads(line)
                if 'text' in data and data['text'] is None:
                    null_lines.append(line_number)
            except json.JSONDecodeError:
                print(f"JSONデコードエラー: 行 {line_number}")
            except KeyError:
                print(f"'text'キーが見つかりません: 行 {line_number}")
            print()
    
    return null_lines

def print_null_text_lines(file_path:str, print_line_number:int):
    with open(file_path, 'r', encoding='utf-8') as file:
        for line_number, line in enumerate(file, start=1):
            print(f"処理中: 行 {line_number}", end='\r')  # 現在の行数を表示
            if print_line_number == line_number:
                try:
                    data = json.loads(line)
                    print(print_line_number,":",line,"\t",data)
                    print(f"行 {line_number} のデータ:")
                    print(json.dumps(data, indent=2, ensure_ascii=False))
                except:
                    print("読み込みエラー")

# print_null_text_lines("./results/dataset/paraphrased_train.jsonl",258545869)
def calculate_text_byte_size(jsonl_file_path:str):
    byte_size=0
    with open(jsonl_file_path, 'r', encoding='utf-8') as file:
        for line_number, line in enumerate(file, start=1):
            print(f"処理中: 行 {line_number}", end='\r')  # 現在の行数を表示
            try:
                json_obj = json.loads(line.strip())
                text = json_obj.get('text', '')
                byte_size += len(text.encode('utf-8'))
                # print(f"Text byte size: {byte_size}")
            except json.JSONDecodeError:
                print(f"Invalid JSON: {line}")
    print("total byte size:",byte_size)

jsonl_file_path = './externals/corpus-cleaner/results/data/wiki/cleaned/wiki_train.jsonl'
calculate_text_byte_size(jsonl_file_path)

# # 関数の使用例
# file_path = 'path/to/your/file.jsonl'
# null_text_lines = find_null_text_lines(file_path)

# print("textキーがNULLとなっている行番号:")
# for line in null_text_lines:
#     print(line)