#!/bin/bash

# Vérifier les arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 <dossier> <base_name>"
    exit 1
fi

# Arguments
dossier="$1"
base_name=$2

# Dossiers et fichiers de sortie
pals_dir="pals"
mkdir -p "$pals_dir"

dump_output="$pals_dir/dumps-text-$base_name.txt"
context_output="$pals_dir/contextes-$base_name.txt"

# Nettoyer les fichiers de sortie si existent
> "$dump_output"
> "$context_output"

# Traiter les fichiers dumps-text
for file in "$dossier/dumps-text"/*.txt; do
    echo "Traitement du fichier : $file"

    # Ajouter chaque mot du fichier à la sortie (un mot par ligne)
    while IFS= read -r line; do
        # 处理中文字符并逐个字符输出
        echo "$line" | tr -s ' ' '\n' >> "$dump_output"
    done < "$file"

    # Ajouter une ligne vide pour séparer les fichiers
    echo "" >> "$dump_output"
done

echo "Fichier dump créé : $dump_output"

# Traiter les fichiers contextes
for file in "$dossier/context"/*.txt; do
    echo "Traitement du fichier : $file"

    # Ajouter chaque mot du contexte avec une séparation claire
    while IFS= read -r line; do
        # 处理中文字符并逐个字符输出
        echo "$line" | tr -s ' ' '\n' >> "$context_output"
    done < "$file"

    # Ajouter une ligne vide pour séparer les fichiers
    echo "" >> "$context_output"
done

echo "Fichier contextes créé : $context_output"

echo "Tous les fichiers PALS sont prêts dans le dossier $pals_dir"
