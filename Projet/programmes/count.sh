#!/usr/bin/env bash

# verifier les arguments
if [ $# -ne 1 ]; then
    echo "用法：$0 <url列表文件>"
    exit 1
fi

urlfile=$1     # URLs
num_ligne=1    # compter les lignes

mkdir -p aspirations dumps-text tableaux

# partie html
cat <<EOF > ./tableaux/tableau_en.html
<html>
<head>
    <meta charset="UTF-8">
    <title>Statistiques : keyword "root"</title>
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
                <th>Occurrences of "root"</th>
                <th>Aspiration (HTML)</th>
                <th>Dump (TXT)</th>
            </tr>
        </thead>
        <tbody>
EOF

# read URLs from file
while read -r line; do

    reponse=$(curl -s -L -w "%{content_type}\t%{http_code}" -o "./aspirations/en-$num_ligne.html" "$line")

    content_type=$(echo "$reponse" | cut -f1)
    http_code=$(echo "$reponse" | cut -f2)

    encodage=$(echo "$content_type" | egrep -o "charset=[^ ;]+" | cut -d '=' -f2)
    encodage=${encodage:-"N/A"}

    if [ "$http_code" != "200" ]; then
        nb_mots="/"
        occur="/"
    else
        lynx -dump -nolist "./aspirations/en-$num_ligne.html" > "./dumps-text/en-$num_ligne.txt"

        nb_mots=$(wc -w < "./dumps-text/en-$num_ligne.txt")

        occur=$(egrep -io '\broot\b' "./dumps-text/en-$num_ligne.txt" | wc -l)
    fi

    aspiration="<a href=\"../aspirations/en-$num_ligne.html\">HTML</a>"
    dump="<a href=\"../dumps-text/en-$num_ligne.txt\">TXT</a>"

    cat <<ROW >> ./tableaux/tableau_en.html
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

cat <<EOF >> ./tableaux/tableau_en.html
        </tbody>
    </table>
</body>
</html>
EOF
