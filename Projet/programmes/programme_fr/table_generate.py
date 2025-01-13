#!/usr/bin/env python3

import os

# Fonction pour générer le lien vers un fichier local
def generate_link(file_path):
    # Base URL locale pour les fichiers dans le dossier "tableaux"
    base_url = './tableaux'  # Chemin local vers le dossier "tableaux"
    file_path = file_path.replace('./', '').replace(' ', '%20')  # Remplace les espaces et la racine
    return f"{base_url}/{file_path}"

# Fonction pour compter le nombre de mots dans un fichier
def count_words(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            text = file.read()
            words = text.split()  # Découper le texte en mots
            return len(words)
    except Exception as e:
        print(f"Erreur lors du comptage des mots dans le fichier {file_path}: {e}")
        return 0

# Fonction pour compter le nombre de lignes dans un fichier (pour le compte)
def count_lines(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            return len(file.readlines())
    except Exception as e:
        print(f"Erreur lors du comptage des lignes dans le fichier {file_path}: {e}")
        return 0

# Fonction pour générer le fichier HTML
def generate_html():
    # Définir les répertoires en remontant d'un niveau vers le parent
    contextes_dir = '../contextes'  # Remonter d'un niveau pour atteindre 'contextes'
    aspirations_dir = '../aspirations'
    concordances_dir = '../concordances'
    dumps_dir = '../dumps-text'
    tableaux_dir = '../tableaux'  # Le dossier tableaux est aussi au même niveau que 'programmes'

    # Vérification que tous les dossiers existent
    for dir_name in [contextes_dir, aspirations_dir, concordances_dir, dumps_dir, tableaux_dir]:
        if not os.path.exists(dir_name):
            print(f"Erreur: Le dossier '{dir_name}' n'existe pas.")
            return
    
    # Initialisation du tableau des résultats
    html_content = """
<!DOCTYPE html>
<html lang='fr' class='has-background-dark'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>Tableau - Liens Français</title>
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
        <h1 class='title has-text-centered has-text-light is-2'>Tableau des Liens - Français</h1>
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
                <tbody>
    """
    
    # Parcours des fichiers contextes pour créer les entrées du tableau
    num = 1
    for context_file in os.listdir(contextes_dir):
        if context_file.startswith("fr_"):  # Filtre les fichiers qui commencent par 'fr_'
            # Détails de chaque ligne à ajouter dans le tableau HTML
            file_base_name = context_file.replace("fr_", "").replace(".txt", "")
            
            # Génération des liens
            dump_link = generate_link(f"dumps-text/fr_{file_base_name}.txt")
            aspirations_link = generate_link(f"aspirations/fr_{file_base_name}.html")
            contextes_link = generate_link(f"contextes/fr_{file_base_name}.txt")
            concordances_link = generate_link(f"concordances/fr_{file_base_name}.html")
            
            # Compter le nombre de mots dans les fichiers contextes et dumps-text
            contextes_word_count = count_words(f"{contextes_dir}/fr_{file_base_name}.txt")
            dumps_word_count = count_words(f"{dumps_dir}/fr_{file_base_name}.txt")
            
            # Compter le nombre de lignes dans les fichiers contextes (pour le "compte")
            contextes_line_count = count_lines(f"{contextes_dir}/fr_{file_base_name}.txt")
            dumps_line_count = count_lines(f"{dumps_dir}/fr_{file_base_name}.txt")

            # Remplir le tableau avec les données
            html_content += f"""
            <tr>
                <td>{num}</td>
                <td>fr.wiktionary.org</td>
                <td><a href='https://fr.wiktionary.org/wiki/{file_base_name}' target='_blank'>https://fr.wiktionary.org/wiki/{file_base_name}</a></td>
                <td>200</td>  <!-- Code HTTP statique -->
                <td>UTF-8</td> <!-- Encodage statique -->
                <td>{contextes_word_count}</td>  <!-- Nombre de mots dans contextes -->
                <td>{contextes_line_count}</td>  <!-- Nombre de lignes dans contextes -->
                <td><a href='{dump_link}' target='_blank'>dump</a></td>
                <td><a href='{aspirations_link}' target='_blank'>aspirations</a></td>
                <td><a href='{contextes_link}' target='_blank'>contextes</a></td>
                <td><a href='{concordances_link}' target='_blank'>concordances</a></td>
            </tr>
            """
            num += 1

    # Fin du tableau et du document HTML
    html_content += """
                </tbody>
        </table>
    </div>
  </section>

</body>
</html>
"""
    
    # Enregistrer le fichier HTML généré dans le dossier "tableaux"
    with open(f"{tableaux_dir}/tableau_fr.html", "w", encoding="utf-8") as f:
        f.write(html_content)
    print("Le fichier 'tableau_fr.html' a été généré avec succès dans le dossier 'tableaux'!")

# Appeler la fonction pour générer le tableau
generate_html()


# Rendre le script exécutable :
# chmod +x table_generate.py

# Exécuter le script :
# ./table_generate.py