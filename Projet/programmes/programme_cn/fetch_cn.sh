#!/usr/bin/env bash

# 验证参数
if [ $# -ne 1 ]; then
    echo "用法：$0 <url列表文件>"
    exit 1
fi

urlfile=$1
num_ligne=1

mkdir -p aspirations dumps-text tableaux

# 创建 HTML 表头
cat <<EOF > ./tableaux/tableau_cn.html
<html>
<head>
    <meta charset="UTF-8">
    <title>Statistiques : keyword "根"</title>
</head>
<body>
    <table border="1" cellspacing="0" cellpadding="5">
        <thead>
            <tr>
                <th>ID</th>
                <th>URL</th>
                <th>HTTP Code</th>
                <th>Encodage</th>
                <th>Word Count</th>
                <th>Occurrences of "根"</th>
                <th>Aspiration (HTML)</th>
                <th>Dump (TXT)</th>
            </tr>
        </thead>
        <tbody>
EOF

# 处理每个 URL
while read -r line; do
    # 抓取网页并强制为 UTF-8 编码
    reponse=$(curl -s -L --header "Accept-Charset: utf-8" -w "%{content_type}\t%{http_code}" -o "./aspirations/cn-$num_ligne.html" "$line")

    content_type=$(echo "$reponse" | cut -f1)
    http_code=$(echo "$reponse" | cut -f2)
    encodage=$(echo "$content_type" | egrep -o "charset=[^ ;]+" | cut -d '=' -f2)
    encodage=${encodage:-"N/A"}

    if [ "$http_code" != "200" ]; then
        nb_mots="/"
        occur="/"
    else
        # 提取纯文本并确保编码正确
        lynx -assume_charset=UTF-8 -display_charset=UTF-8 -dump -nolist "./aspirations/cn-$num_ligne.html" > "./dumps-text/cn-$num_ligne.txt"

        # 强制转换为 UTF-8
        iconv -f "$(file -bi "./dumps-text/cn-$num_ligne.txt" | sed -n 's/.*charset=//p')" -t UTF-8 "./dumps-text/cn-$num_ligne.txt" -o "./dumps-text/cn-$num_ligne.txt"

        # 统计词频
        nb_mots=$(wc -w < "./dumps-text/cn-$num_ligne.txt")
        occur=$(grep -o '根' "./dumps-text/cn-$num_ligne.txt" | wc -l)
    fi

    aspiration="<a href=\"../aspirations/cn-$num_ligne.html\">HTML</a>"
    dump="<a href=\"../dumps-text/cn-$num_ligne.txt\">TXT</a>"

    # 写入 HTML 表格
    cat <<ROW >> ./tableaux/tableau_cn.html
            <tr>
                <td>$num_ligne</td>
                <td><a href="$line">$line</a></td>
                <td>$http_code</td>
                <td>$encodage</td>
                <td>$nb_mots</td>
                <td>$occur</td>
                <td>$aspiration</td>
                <td>$dump</td>
            </tr>
ROW

    num_ligne=$((num_ligne + 1))

done < "$urlfile"

# 完成 HTML
cat <<EOF >> ./tableaux/tableau_cn.html
        </tbody>
    </table>
</body>
</html>
EOF

