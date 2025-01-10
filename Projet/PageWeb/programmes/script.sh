#!/bin/bash

# Vérifier les arguments
if [ $# -lt 3 ]; then
    echo "Usage: $0 <url_list> <target_word> <lang_code>"
    exit 1
fi

# Les arguments
URL_LIST=$1
TARGET_WORD=$2
LANG=$3
ASPI_DIR="aspirations"
DUMP_DIR="dumps-text"
CONTEXT_DIR="contextes"
CONCORD_DIR="concordances"

# Créer les dossiers de sortie
mkdir -p "$ASPI_DIR" "$DUMP_DIR" "$CONTEXT_DIR" "$CONCORD_DIR"

# Boucle sur chaque URL
while read -r URL; do
    echo "Processing $URL"
    if [[ -n "$URL" ]]; then
        FILENAME=$(basename "$URL" | awk -F'?' '{print $1}')
        echo "Filename: $FILENAME"

        # Télécharger le HTML
        HTML_FILE="$ASPI_DIR/${LANG}_${FILENAME}.html"
        echo "HTML_FILE path : $HTML_FILE"
        curl -s "$URL" -o "$HTML_FILE"
        if [ ! -s "$HTML_FILE" ]; then
            echo "Erreur : impossible de télécharger $URL" >&2
            continue
        fi

        # Extraire le texte
        TEXT_FILE="$DUMP_DIR/${LANG}_${FILENAME}.txt"
        echo "Extracting text from $HTML_FILE..."
        lynx -dump "$HTML_FILE" > "$TEXT_FILE"
        if [ ! -s "$TEXT_FILE" ]; then
            echo "Erreur : impossible d'extraire le texte de $HTML_FILE" >&2
            continue
        fi

        # Compter les occurrences
        WORD_COUNT=$(grep -o -i "\b$TARGET_WORD\b" "$TEXT_FILE" | wc -l)
        echo "$FILENAME: $WORD_COUNT" >> "$DUMP_DIR/${LANG}_word_count.txt"

        # Extraire les contextes
        CONTEXT_FILE="$CONTEXT_DIR/${LANG}_${FILENAME}.txt"
        grep -i -C 2 "$TARGET_WORD" "$TEXT_FILE" > "$CONTEXT_FILE"

        # Générer un tableau de concordance
        CONCORD_FILE="$CONCORD_DIR/${LANG}_${FILENAME}.html"
        echo "Generating concordance table for $FILENAME..."
        echo "<html><body><table border='1'>" > "$CONCORD_FILE"
        echo "<tr><th>Left Context</th><th>Target Word</th><th>Right Context</th></tr>" >> "$CONCORD_FILE"
        grep -i -C 2 "$TARGET_WORD" "$TEXT_FILE" | while read -r LINE; do
            LEFT=$(echo "$LINE" | awk -v word="$TARGET_WORD" '{split($0, a, word); print a[1]}')
            RIGHT=$(echo "$LINE" | awk -v word="$TARGET_WORD" '{split($0, a, word); print a[2]}')

            echo "<tr><td>$LEFT</td><td>$TARGET_WORD</td><td>$RIGHT</td></tr>" >> "$CONCORD_FILE"
        done
        echo "</table></body></html>" >> "$CONCORD_FILE"
    fi
done < "$URL_LIST"

echo "C'EST BON. Vérifiez les dossiers $ASPI_DIR, $DUMP_DIR, $CONTEXT_DIR, et $CONCORD_DIR pour les résultats."
