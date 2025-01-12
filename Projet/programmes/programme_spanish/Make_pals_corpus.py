#!/usr/bin/env python
# coding: utf-8

# In[3]:


import os

def charger_dictionnaire_dossier(dossier_dictionnaire):
    
    dictionnaire = set()

    # Parcours de tous les fichiers dans le dossier dictionnaire
    for fichier in os.listdir(dossier_dictionnaire):
        chemin_fichier = os.path.join(dossier_dictionnaire, fichier)
        if fichier.endswith(".txt") and os.path.isfile(chemin_fichier):
            with open(chemin_fichier, 'r', encoding='utf-8') as f:
                for ligne in f:
                    # Ajouter chaque mot au dictionnaire (en supprimant les espaces inutiles)
                    dictionnaire.add(ligne.strip().lower())  # On convertit en minuscule pour normaliser
    return dictionnaire

def formater_fichier_pals(nom_fichier_entrer, nom_fichier_sortie, dictionnaire):
    
    with open(nom_fichier_entrer, 'r', encoding='utf-8') as f_in:
        contenu = f_in.read()

    mots = contenu.split()

    with open(nom_fichier_sortie, 'a', encoding='utf-8') as f_out:
        for mot in mots:
            # Si le mot est dans le dictionnaire, on l'écrit dans le fichier de sortie
            if mot.lower() in dictionnaire:
                f_out.write(mot + '\n')  # Ecrire chaque mot sur une nouvelle ligne
        f_out.write('\n')  # Ajouter une ligne vide

def formater_fichiers_dans_dossier(dossier_entree, dossier_sortie, nom_fichier_sortie, dictionnaire):
    
    # Vérifier si le dossier d'entrée existe
    if not os.path.isdir(dossier_entree):
        print("Le dossier d'entrée spécifié n'existe pas.")
        return

    # Vérifier si le dossier de sortie existe, sinon le créer
    if not os.path.exists(dossier_sortie):
        os.makedirs(dossier_sortie)

    # Créer ou vider le fichier de sortie
    fichier_sortie = os.path.join(dossier_sortie, nom_fichier_sortie)
    if os.path.exists(fichier_sortie):
        os.remove(fichier_sortie)

    # Parcours de tous les fichiers dans le dossier d'entrée
    for nom_fichier in os.listdir(dossier_entree):
        if nom_fichier.endswith(".txt"):
            chemin_fichier_entrer = os.path.join(dossier_entree, nom_fichier)

            print(f"Formatage du fichier {nom_fichier}...")
            formater_fichier_pals(chemin_fichier_entrer, fichier_sortie, dictionnaire)
            print(f"Fichier {nom_fichier} formaté avec succès.")

    print(f"Tous les fichiers ont été formatés. Le fichier de sortie est : {fichier_sortie}")

# Spécifier le dossier contenant les fichiers .txt
dossier_entree = input("Veuillez entrer le chemin du dossier contenant les fichiers .txt à formater : ")

# Spécifier le dossier de sortie pour le fichier formaté
dossier_sortie = input("Veuillez entrer le chemin du dossier où le fichier formaté sera sauvegardé : ")

# Spécifier le nom du fichier formaté
nom_fichier_sortie = input("Veuillez entrer le nom du fichier formaté : ")

# Spécifier le chemin du dossier contenant le dictionnaire
dossier_dictionnaire = input("Veuillez entrer le chemin du dossier contenant les fichiers dictionnaire (fichiers .txt) : ")

# Charger le dictionnaire à partir du dossier
dictionnaire = charger_dictionnaire_dossier(dossier_dictionnaire)

# Lancer le processus de formatage
formater_fichiers_dans_dossier(dossier_entree, dossier_sortie, nom_fichier_sortie, dictionnaire)


# In[ ]:




