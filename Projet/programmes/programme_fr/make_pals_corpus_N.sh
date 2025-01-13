#!/bin/bash

# Vérifier les arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 <dossier> <base_name>"
    exit 1
fi

# Arguments
dossier="$1"
base_name="$2"

# Dossier de sortie
pals_dir="$dossier/pals"
mkdir -p "$pals_dir"

# Nom du fichier de sortie
output_file="$pals_dir/dump-$base_name.txt"

# Nettoyer le fichier de sortie s'il existe déjà
> "$output_file"

# Traiter les fichiers dumps correspondant au nom de base
for file in "$dossier/dumps-text/$base_name"*.txt; do
    echo "Traitement du fichier : $file"

    # Lire chaque ligne du fichier et l'ajouter à la sortie
    while read -r line; do
        # Normaliser les lignes en minuscules, enlever les retours à la ligne et les espaces superflus
        normalized_line=$(echo "$line" | tr '[:upper:]' '[:lower:]' | tr -s '[:space:]' ' ')
        
        # Ajouter chaque mot sur une nouvelle ligne dans le fichier de sortie
        for word in $normalized_line; do
            echo "$word" >> "$output_file"
        done
    done < "$file"

    # Ajouter une ligne vide pour séparer les fichiers
    echo "" >> "$output_file"
done

echo "Le fichier de sortie a été créé : $output_file"


# Rendre le script exécutable :
# chmod +x make_pals_corpus_N.sh

# Exécuter le script (le dossier programmes) :
# ./make_pals_corpus_N.sh /chemin/vers/le/dossier lang1

# ./make_pals_corpus_N.sh /chemin/vers/le/dossier lang1

# ./make_pals_corpus_N.sh /Users/nataliakulikova/projet_racine/Travail-Groupe/Projet fr_
