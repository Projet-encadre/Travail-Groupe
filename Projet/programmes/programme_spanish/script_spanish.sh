#!/bin/bash

# Demande où se trouve le fichier .txt contenant les informations
echo "Entrez le chemin du fichier contenant vos liens :"
read links_files

input_file="$links_files"

# Vérifie si le fichier d'entrée existe
if [[ ! -f "$input_file" ]]; then
    echo "Le fichier $input_file n'existe pas."
    exit 1
fi

echo "Entrez le chemin et le nom de votre fichier de sortie TSV (exemple: /chemin/vers/fichier/tableau.tsv) :"
read output_file

# Vérifie si le fichier de sortie TSV existe, sinon le crée
if [[ ! -f "$output_file" || ! -s "$output_file" ]]; then
    echo -e "Numéro\tNom du Site\tURL\tCode HTTP\tEncodage\tNombre de Mots\tOccurrences du Mot" > "$output_file"
fi

# Demande à l'utilisateur où enregistrer le fichier HTML
echo "Entrez le chemin et le nom de votre fichier de sortie HTML (exemple: /chemin/vers/fichier/tableau-fr.html) :"
read html_output_file

# Demande à l'utilisateur quel mot il souhaite rechercher
echo "Entrez le mot dont vous souhaitez compter les occurrences :"
read search_word

# Demander à l'utilisateur de saisir le chemin du dossier de destination pour les dumps textuels
echo "Veuillez entrer le chemin du dossier de destination pour les résultats (dumps textuels) :"
read dossier_destination

# Vérifier si le dossier de destination existe, sinon le créer
if [ ! -d "$dossier_destination" ]; then
    echo "Le dossier '$dossier_destination' n'existe pas. Création du dossier..."
    mkdir -p "$dossier_destination"
fi

# Demander à l'utilisateur de saisir le dossier pour les extraits
echo "Veuillez entrer le chemin du dossier de destination pour les extraits de texte (autour du mot recherché) :"
read dossier_extraits

# Vérifier si le dossier pour les extraits existe, sinon le créer
if [ ! -d "$dossier_extraits" ]; then
    echo "Le dossier '$dossier_extraits' n'existe pas. Création du dossier..."
    mkdir -p "$dossier_extraits"
fi

# Demander à l'utilisateur de fournir le répertoire de destination pour les fichiers HTML téléchargés
echo "Veuillez entrer le chemin du répertoire où enregistrer les fichiers HTML (aspirations) :"
read dossier_html

# Vérifier si le répertoire pour les fichiers HTML existe, sinon le créer
if [ ! -d "$dossier_html" ]; then
    echo "Le répertoire n'existe pas. Création du répertoire $dossier_html."
    mkdir -p "$dossier_html"
fi

line_number=1

# Lecture du fichier d'entrée ligne par ligne
while IFS= read -r url; do
    if [[ -n "$url" ]]; then

        # Ajoute "https://" si l'URL ne le contient pas
        if [[ ! "$url" =~ ^https?:// ]]; then
            url="https://$url"
        fi

        site_name=$(echo "$url" | awk -F[/:] '{print $4}' | sed 's/^www\.//')

        # Obtient les en-têtes HTTP
        response=$(curl -s -I "$url")
        http_code=$(echo "$response" | grep -i "^HTTP" | awk '{print $2}')

        # Si le code HTTP est 200, récupère l'encodage et compte les mots
        if [ "$http_code" = "200" ]; then
            # Extrait l'encodage de l'en-tête Content-Type
            encodage=$(echo "$response" | grep -i "^Content-Type" | sed -n 's/.*charset=\([a-zA-Z0-9-]*\).*/\1/p' | head -n 1)

            # Si aucun encodage n'est trouvé, on définit "UTF-8" par défaut
            encodage=${encodage:-"UTF-8"}

            # Récupère le contenu de la page, compte les mots et les occurrences du mot recherché
            page_content=$(curl -s "$url" | lynx -stdin -dump -nolist)
            word_count=$(echo "$page_content" | wc -w)

            # Compte les occurrences du mot recherché (en ignorant la casse)
            word_occurrences=$(echo "$page_content" | grep -oi "$search_word" | wc -l)
        else
            # Si le code HTTP n'est pas 200, utilise des valeurs par défaut
            encodage="Unknown"
            word_count=0
            word_occurrences=0
        fi


        # Utiliser lynx pour récupérer le dump textuel et enregistrer dans un fichier
        nom_fichier="spanish_$(echo "$url" | sed 's/[^a-zA-Z0-9]/_/g').txt"
        lynx -dump "$url" > "$dossier_destination/$nom_fichier"

        echo "Le contenu de '$url' a été enregistré dans '$dossier_destination/$nom_fichier'."

        # Vérifier si le mot à rechercher existe dans le fichier dumpé (insensible à la casse)
        if grep -iq "$search_word" "$dossier_destination/$nom_fichier"; then
            echo "Le mot '$search_word' a été trouvé dans '$nom_fichier'. Extraction des informations autour de ce mot..."

            # Extraire le texte autour du mot recherché (par exemple, 30 caractères avant et après)
            nom_fichier_extrait="spanish_$(echo "$url" | sed 's/[^a-zA-Z0-9]/_/g').txt"
            egrep -oi ".{0,30}$search_word.{0,30}" "$dossier_destination/$nom_fichier" > "$dossier_extraits/$nom_fichier_extrait"

            echo "L'extrait autour de '$search_word' a été sauvegardé dans '$dossier_extraits/$nom_fichier_extrait'."
        else
            echo "Le mot '$search_word' n'a pas été trouvé dans '$nom_fichier'."
        fi

        # Ajout de la colonne Dump avec un lien cliquable vers un fichier GitHub
        dump_link="<a href='https://github.com/Projet-encadre/Travail-Groupe/tree/main/Projet/dumps-text/spanish_$(echo "$url" | sed 's/[^a-zA-Z0-9]/_/g').txt' target='_blank'>dump</a>"

        # Ajout de la colonne Aspirations avec un lien cliquable vers un fichier GitHub
        aspirations_link="<a href='https://github.com/Projet-encadre/Travail-Groupe/tree/main/Projet/aspirations/spanish_$(echo "$url" | sed 's/[^a-zA-Z0-9]/_/g').html' target='_blank'>aspirations</a>"

        # Ajout de la colonne Contextes avec un lien cliquable vers un fichier GitHub
        contextes_link="<a href='https://github.com/Projet-encadre/Travail-Groupe/tree/main/Projet/contextes/spanish_$(echo "$url" | sed 's/[^a-zA-Z0-9]/_/g').txt' target='_blank'>contextes</a>"

        # Ajout de la colonne Concordances avec un lien cliquable vers un fichier GitHub
        concordances_link="<a href='https://github.com/Projet-encadre/Travail-Groupe/tree/main/Projet/concordances/spanish_$(echo "$url" | sed 's/[^a-zA-Z0-9]/_/g').html' target='_blank'>concordances</a>"

        # Télécharger le contenu HTML avec curl et enregistrer dans le dossier HTML spécifié
        nom_fichier_html=$(echo "$url" | sed -E 's/[^a-zA-Z0-9]/_/g')
        echo "Téléchargement de: $url"
        curl -s "$url" -o "$dossier_html/spanish_$nom_fichier_html.html"

        echo "Le fichier HTML de '$url' a été enregistré dans '$dossier_html/spanish_$nom_fichier_html.html'."

        # Enregistrement des résultats dans le fichier .tsv
        echo -e "${line_number}\t${site_name}\t${url}\t${http_code}\t${encodage}\t${word_count}\t${word_occurrences}\t${dump_link}\t${aspirations_link}\t${contextes_link}\t${concordances_link}" >> "$output_file"

        ((line_number++))

    fi
done < "$input_file"

echo "Les informations ont été enregistrées dans le fichier : $output_file"

# Demande à l'utilisateur s'il souhaite convertir en HTML
echo "Voulez-vous convertir ces informations en fichier HTML ? (oui/non)"
read convert_to_html

if [[ "$convert_to_html" == "oui" ]]; then
    # Création du fichier HTML
    echo "<!DOCTYPE html>
<html lang='fr'class='has-background-dark'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>Tableau - Espagnol</title>
    <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css'>
</head>

<nav class='navbar is-light'>
    <div class='navbar-brand'>
        <a class='navbar-item' href='../../index.html'>
            <h1 class='title is-4'>Racine</h1>
        </a>
    </div>
</nav>

<body>

  <section class='section is-fullheight'>
    <div class='container mt-5'>
        <h1 class='title has-text-centered has-text-light is-2'>Tableau</h1>
        <table class='table is-striped is-bordered is-hoverable is-fullwidth'>
                <thead>
                    <tr>
                        <th>Numéro</th>
                        <th>Nom du Site</th>
                        <th>URL</th>
                        <th>Code HTTP</th>
                        <th>Encodage</th>
                        <th>Nombre de Mots</th>
                        <th>Compte</th>
                        <th>Dump</th>
                        <th>Aspirations</th>
                        <th>Contextes</th>
                        <th>Concordances</th>
                    </tr>
                </thead>
                <tbody>" > "$html_output_file"

    # Lecture du fichier .tsv et conversion des lignes en HTML
    while IFS=$'\t' read -r line_number site_name url http_code encoding word_count word_occurrences dump aspirations contextes concordances; do
        if [[ "$line_number" != "Numéro" ]]; then
            echo "                <tr>
                    <td>${line_number}</td>
                    <td>${site_name}</td>
                    <td><a href='${url}' target='_blank'>${url}</a></td>
                    <td>${http_code}</td>
                    <td>${encoding}</td>
                    <td>${word_count}</td>
                    <td>${word_occurrences}</td>
                    <td>${dump}</td>
                    <td>${aspirations}</td>
                    <td>${contextes}</td>
                    <td>${concordances}</td>
                </tr>" >> "$html_output_file"
        fi
    done < "$output_file"


    echo "      </tbody>
        </table>
    </div>
</section>
</body>
</html>" >> "$html_output_file"

    echo "Les informations ont été converties et enregistrées dans le fichier HTML : $html_output_file"
fi

echo "Traitement terminé. Les fichiers sont enregistrés dans '$dossier_destination', les extraits dans '$dossier_extraits' et les fichiers HTML dans '$dossier_html'."

# Demander le répertoire et le mot à rechercher pour la concordance
echo "Entrez le chemin du dossier contenant les fichiers .txt pour la concordance :"
read directory

# Créer le répertoire de sortie pour la concordance
echo "Entrez le chemin du répertoire où enregistrer les fichiers HTML de la concordance :"
read output_concordance_html

mkdir -p "$output_concordance_html"

# Parcourir tous les fichiers .txt dans le répertoire pour générer les fichiers HTML de concordance
for file in "$directory"/*.txt; do
    if [[ -f "$file" ]]; then
        output_file="$output_concordance_html/$(basename "${file%.txt}.html")"
        echo "<html><body><table border='1'>" > "$output_file"
        echo "<tr><th>Contexte (gauche)</th><th>Mot ciblé</th><th>Contexte (droite)</th></tr>" >> "$output_file"

        grep -i -C 2 "$search_word" "$file" | while read -r LINE; do
            LEFT=$(echo "$LINE" | awk -v word="$search_word" '{split($0, a, word); print a[1]}')
            RIGHT=$(echo "$LINE" | awk -v word="$search_word" '{split($0, a, word); print a[2]}')

            echo "<tr><td>$LEFT</td><td>$search_word</td><td>$RIGHT</td></tr>" >> "$output_file"
        done
        echo "</table></body></html>" >> "$output_file"
    fi
done

echo "La conversion en HTML de la concordance est terminée."
