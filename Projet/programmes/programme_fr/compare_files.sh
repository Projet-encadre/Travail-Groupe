#!/bin/bash

# Définir le chemin vers le dossier pals
PALS_DIR="../pals"

# Fichiers de référence (les tiens)
MY_CONTEXT="$PALS_DIR/contextes-fr_racine.txt"
MY_DUMP="$PALS_DIR/dump-fr_.txt"

# Vérifier si les fichiers de référence existent
if [ ! -f "$MY_CONTEXT" ]; then
    echo "Fichier $MY_CONTEXT introuvable."
    exit 1
fi

if [ ! -f "$MY_DUMP" ]; then
    echo "Fichier $MY_DUMP introuvable."
    exit 1
fi

# Comparer les contextes
echo "Début des comparaisons des contextes..."
for other_context in "$PALS_DIR"/contextes-*.txt; do
    if [ "$other_context" != "$MY_CONTEXT" ]; then
        echo "Comparaison : $MY_CONTEXT avec $other_context"
        python3 ./partition.py -i "$MY_CONTEXT" -i "$other_context"
    fi
done

# Comparer les dumps
echo "Début des comparaisons des dumps..."
for other_dump in "$PALS_DIR"/dump-*.txt; do
    if [ "$other_dump" != "$MY_DUMP" ]; then
        echo "Comparaison : $MY_DUMP avec $other_dump"
        python3 ./cooccurrents.py -i "$MY_DUMP" -i "$other_dump"
    fi
done

echo "Toutes les comparaisons sont terminées."


# Rendre le script exécutable :
# chmod +x programmes/compare_files.sh

# Lancer le script depuis "programmes" :
# cd programmes
# ./compare_files.sh
