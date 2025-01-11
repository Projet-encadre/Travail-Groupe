#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re

def find_concordances_and_context(
    folder_path,       # 原文本所在的文件夹，如 "dumps-text"
    keyword="root",    # 要搜索的关键词
    window_words=5,    # 单词上下文窗口大小
    context_chars=30,  # 字符上下文窗口大小
    out_folder_words="contexte",
    out_folder_chars="concordance",
    max_files=50       # 假设你有 en-1 ~ en-50
):
    """
    从 folder_path 下 (en-1.txt ~ en-max_files.txt) 找到 keyword 的出现位置，
    并将结果分别保存到 out_folder_words/ 和 out_folder_chars/ 下。
    """

    # 如果输出文件夹不存在，则创建
    os.makedirs(out_folder_words, exist_ok=True)
    os.makedirs(out_folder_chars, exist_ok=True)

    # 准备用于整词匹配的正则 (忽略大小写)
    pattern_word = re.compile(rf"^{keyword}$", re.IGNORECASE)
    # 准备用于字符匹配 (出现就行，不要求整词边界)
    pattern_char = re.compile(re.escape(keyword), re.IGNORECASE)

    for i in range(1, max_files + 1):
        filename = f"en-{i}.txt"
        file_path = os.path.join(folder_path, filename)

        if not os.path.isfile(file_path):
            continue  # 不存在就跳过

        # 读取文件内容（如果有编码问题，可加 errors='replace'）
        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
            text = f.read()

        #----------------------------------------------------------------------
        # 1) 生成基于“单词窗口”的上下文 (contexte)
        #----------------------------------------------------------------------
        tokens = re.split(r"\s+", text)  # 按空白分词
        word_snippets = []

        for idx, token in enumerate(tokens):
            if pattern_word.match(token):  
                # 命中关键词（整词匹配，忽略大小写）
                start = max(0, idx - window_words)
                end = min(len(tokens), idx + window_words + 1)
                snippet = " ".join(tokens[start:end])
                word_snippets.append(snippet)

        # 将结果写入 contexte/en-i.txt
        out_words_path = os.path.join(out_folder_words, filename)
        with open(out_words_path, "w", encoding="utf-8") as out_w:
            if not word_snippets:
                out_w.write("(No occurrences found)\n")
            else:
                for snippet in word_snippets:
                    out_w.write(snippet + "\n")

        #----------------------------------------------------------------------
        # 2) 生成基于“字符窗口”的上下文 (concordance)
        #----------------------------------------------------------------------
        char_snippets = []
        for match in pattern_char.finditer(text):
            # match.start() = 关键词开头在整个文本的索引
            start_idx = max(0, match.start() - context_chars)
            end_idx = min(len(text), match.end() + context_chars)
            snippet = text[start_idx:end_idx]
            char_snippets.append(snippet)

        # 将结果写入 concordance/en-i.txt
        out_chars_path = os.path.join(out_folder_chars, filename)
        with open(out_chars_path, "w", encoding="utf-8") as out_c:
            if not char_snippets:
                out_c.write("(No occurrences found)\n")
            else:
                for snippet in char_snippets:
                    # 为了更好阅读，可把换行替换掉或缩进；这里简单直接写
                    out_c.write(snippet.replace("\n", " ") + "\n")


if __name__ == "__main__":
    # 配置：假设源文件都在 "dumps-text" 文件夹内
    source_folder = "."

    # 批量处理 en-1.txt ~ en-50.txt
    find_concordances_and_context(
        folder_path=source_folder,
        keyword="root",          # 要检索的关键词
        window_words=5,          # 单词上下文：左右各 5 个词
        context_chars=30,        # 字符上下文：左右各 30 个字符
        out_folder_words="contexte",
        out_folder_chars="concordance",
        max_files=50
    )
