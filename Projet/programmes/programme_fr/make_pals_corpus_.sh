#!/bin/bash

# Vérifier les arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 <dossier>"
    exit 1
fi

# Arguments
dossier="$1"

# Dossiers et fichiers de sortie
pals_dir="$dossier/pals"
mkdir -p "$pals_dir"

context_output="$pals_dir/contextes-fr_racine.txt"

# Nettoyer le fichier de sortie s'il existe
> "$context_output"

# Utiliser chardet pour détecter l'encodage et ouvrir les fichiers correctement
python3 - <<EOF
import os
import chardet

# Vérifier les fichiers dans le dossier dumps-text
dossier = "$dossier"
dump_folder = os.path.join(dossier, "dumps-text")
context_output = "$context_output"

with open(context_output, "a", encoding="utf-8") as output_file:
    # Traiter les fichiers dumps-text
    for file_name in os.listdir(dump_folder):
        file_path = os.path.join(dump_folder, file_name)

        if file_name.startswith("fr_") and file_name.endswith(".txt"):
            print(f"Traitement du fichier : {file_path}")

            # Détection de l'encodage avec chardet
            with open(file_path, 'rb') as file:
                raw_data = file.read()
                result = chardet.detect(raw_data)
                encoding = result['encoding']
                print(f"Encodage détecté pour {file_path} : {encoding}")

            # Lire le fichier avec l'encodage détecté
            with open(file_path, 'r', encoding=encoding) as file:
                for line in file:
                    # Normaliser tout en minuscule
                    lower_line = line.lower()

                    # Afficher chaque ligne avant traitement pour vérifier
                    print(f"Ligne brute : {line.strip()}")
                    print(f"Ligne normalisée : {lower_line.strip()}")

                    # Trouver les phrases contenant "racine" et extraire les 5 mots avant et après
                    match = " ".join(lower_line.split())
                    if "racine" in match:
                        context = match.split("racine")
                        before_racine = " ".join(context[0].split()[-5:])
                        after_racine = " ".join(context[1].split()[:5])
                        context_str = f"{before_racine} racine {after_racine}"
                        output_file.write(f"{context_str}\n")
                output_file.write("\n")

print(f"Traitement terminé. Les contextes sont sauvegardés dans {context_output}")
EOF

# Donner les permissions d'exécution au script :
# chmod +x make_pals_corpus_.sh

# Lancer le script (depuis le dossier "Projet") :
# ./programmes/make_pals_corpus_.sh .