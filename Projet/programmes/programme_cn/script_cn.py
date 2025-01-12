import os
import re

def process_chinese_text(
    folder_path,       # 文本文档所在的文件夹
    keyword="根",       # 要搜索的关键词
    context_chars=20,  # 字符上下文窗口大小
    out_folder="context",  # 保存上下文的输出文件夹
    max_files=20       # 处理的文本文档数量（cn-1 到 cn-20）
):
    """
    统计每个文本文档的字数，关键词出现次数，并提取上下文。
    """
    # 如果输出文件夹不存在，则创建
    os.makedirs(out_folder, exist_ok=True)

    # 结果统计
    stats = []

    for i in range(1, max_files + 1):
        filename = f"cn-{i}.txt"
        file_path = os.path.join(folder_path, filename)

        if not os.path.isfile(file_path):
            print(f"文件 {filename} 不存在，跳过。")
            continue

        # 读取文件内容，假设文件为 UTF-8 编码
        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
            text = f.read()

        # 统计字数（中文文本中的每个字符计为一个字）
        total_chars = len(text)

        # 统计关键词出现次数
        keyword_count = len(re.findall(re.escape(keyword), text))

        # 提取关键词的上下文
        context_snippets = []
        for match in re.finditer(re.escape(keyword), text):
            start_idx = max(0, match.start() - context_chars)
            end_idx = min(len(text), match.end() + context_chars)
            snippet = text[start_idx:end_idx]
            context_snippets.append(snippet)

        # 保存上下文到文件
        output_file = os.path.join(out_folder, f"context-cn-{i}.txt")
        with open(output_file, "w", encoding="utf-8") as out_f:
            if not context_snippets:
                out_f.write("未找到关键词的上下文。\n")
            else:
                for snippet in context_snippets:
                    out_f.write(snippet.replace("\n", " ") + "\n")

        # 保存统计信息
        stats.append({
            "file": filename,
            "total_chars": total_chars,
            "keyword_count": keyword_count,
            "output_file": output_file
        })

    # 输出统计结果
    print(f"{'文件名':<15}{'字数':<10}{'关键词次数':<10}{'上下文文件':<20}")
    print("-" * 60)
    for stat in stats:
        print(f"{stat['file']:<15}{stat['total_chars']:<10}{stat['keyword_count']:<10}{stat['output_file']:<20}")

if __name__ == "__main__":
    # 配置路径和参数
    source_folder = "."  # 文本文档所在的文件夹
    process_chinese_text(
        folder_path=source_folder,
        keyword="根",          # 要统计的关键词
        context_chars=20,      # 上下文字符窗口大小
        out_folder="context",  # 保存上下文的文件夹
        max_files=20           # 要处理的文本文档数量
    )
