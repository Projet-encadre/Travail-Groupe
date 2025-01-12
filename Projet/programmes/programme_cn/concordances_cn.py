import os
import re
from bs4 import BeautifulSoup

def extract_contexts(text, keyword, max_chars=20):
    """
    提取文本中关键词的左右上下文。
    :param text: 要处理的文本
    :param keyword: 关键词
    :param max_chars: 左右上下文的最大长度
    :return: 左右上下文的列表
    """
    contexts = []
    for match in re.finditer(re.escape(keyword), text):
        start = match.start()
        end = match.end()

        # 找到左侧上下文
        left_context_start = max(0, start - max_chars)
        left_context = text[left_context_start:start]
        left_context = re.split(r'[，。！？；：]', left_context)[-1]  # 切到最近标点

        # 找到右侧上下文
        right_context_end = min(len(text), end + max_chars)
        right_context = text[end:right_context_end]
        right_context = re.split(r'[，。！？；：]', right_context)[0]  # 切到最近标点

        contexts.append((left_context.strip(), keyword, right_context.strip()))
    return contexts

def generate_html_table(contexts, output_file):
    """
    生成 HTML 表格显示上下文。
    :param contexts: 上下文列表
    :param output_file: 保存的 HTML 文件路径
    """
    html = """
    <html>
    <head>
        <meta charset="UTF-8">
        <title>关键词上下文</title>
    </head>
    <body>
        <table border="1" cellpadding="5" cellspacing="0">
            <thead>
                <tr>
                    <th>Contexte gauche</th>
                    <th>Mot Clé</th>
                    <th>Contexte droite</th>
                </tr>
            </thead>
            <tbody>
    """
    for left, keyword, right in contexts:
        html += f"""
        <tr>
            <td>{left}</td>
            <td><strong>{keyword}</strong></td>
            <td>{right}</td>
        </tr>
        """
    html += """
            </tbody>
        </table>
    </body>
    </html>
    """
    with open(output_file, "w", encoding="utf-8") as f:
        f.write(html)

def process_files(input_folder, keyword, output_folder, max_chars=20):
    """
    处理文件夹中的所有文本文件，提取关键词上下文并生成 HTML。
    :param input_folder: 输入文本文件夹
    :param keyword: 要提取的关键词
    :param output_folder: 输出 HTML 文件夹
    :param max_chars: 上下文最大字符数
    """
    os.makedirs(output_folder, exist_ok=True)

    for i in range(1, 21):  # 假设处理 20 个文件
        input_file = os.path.join(input_folder, f"context-cn-{i}.txt")
        output_file = os.path.join(output_folder, f"context-cn-{i}.html")

        if not os.path.isfile(input_file):
            print(f"文件 {input_file} 不存在，跳过。")
            continue

        with open(input_file, "r", encoding="utf-8") as f:
            text = f.read()

        contexts = extract_contexts(text, keyword, max_chars)
        generate_html_table(contexts, output_file)
        print(f"已生成 {output_file}")

def main():
    input_folder = "context"  # 输入文件夹路径
    output_folder = "concordances"  # 输出文件夹路径
    keyword = "根"  # 要搜索的关键词
    max_chars = 20  # 上下文字符长度限制

    process_files(input_folder, keyword, output_folder, max_chars)

if __name__ == "__main__":
    main()
