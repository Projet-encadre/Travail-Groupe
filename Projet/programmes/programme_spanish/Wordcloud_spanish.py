#!/usr/bin/env python
# coding: utf-8


import os
from wordcloud import WordCloud, STOPWORDS
import matplotlib.pyplot as plt
import numpy as np
from PIL import Image
import string

def extraire_texte_du_dossier(dossier):
    """
    Fonction pour extraire tout le texte des fichiers .txt dans un dossier.
    """
    texte_complet = ""
    for fichier in os.listdir(dossier):
        if fichier.endswith(".txt"):
            chemin_fichier = os.path.join(dossier, fichier)
            with open(chemin_fichier, "r", encoding="utf-8") as file:
                texte_complet += file.read() + " "  # Ajoute le texte de chaque fichier au texte complet
    return texte_complet

def nettoyer_texte(texte):
    """
    Fonction pour nettoyer le texte : conversion en minuscules, suppression de la ponctuation.
    """
    # Convertir en minuscules
    texte = texte.lower()
    
    # Suppression de la ponctuation
    texte = texte.translate(str.maketrans("", "", string.punctuation))
    
    return texte

def charger_dictionnaire_espagnol(dossier_dico):
    """
    Charger un dictionnaire de mots espagnols à partir de plusieurs fichiers dans un dossier.
    """
    mots_espagnols = set()
    
    # Parcours de tous les fichiers du dossier
    for fichier in os.listdir(dossier_dico):
        if fichier.endswith(".txt"):  # On s'assure qu'on prend bien des fichiers .txt
            chemin_fichier = os.path.join(dossier_dico, fichier)
            with open(chemin_fichier, "r", encoding="utf-8") as f:
                # Ajouter les mots du fichier au dictionnaire
                mots_espagnols.update(f.read().splitlines())
    
    return mots_espagnols

def creer_nuage_de_mots(texte, mot_cle, image_mask_path, taille_image=(800, 400), output_path="nuage_mots.png", mots_vides=set(), mots_espagnols=set()):
    """
    Crée un nuage de mots autour du mot clé défini par l'utilisateur en utilisant un masque (forme personnalisée).
    Le nuage de mots est sauvegardé sous forme d'image.
    """
    # Nettoyer le texte
    texte = nettoyer_texte(texte)

    # Séparer le texte en mots
    mots = texte.split()

    # Garder seulement les mots en espagnol
    mots_en_espagnol = [mot for mot in mots if mot in mots_espagnols]

    # Ajouter des mots vides personnalisés à la liste STOPWORDS de WordCloud
    stopwords = STOPWORDS.union(mots_vides)

    # Charger l'image du masque pour la forme
    masque = np.array(Image.open(image_mask_path))

    # Générer un nuage de mots avec un masque pour donner la forme désirée
    wordcloud = WordCloud(
        width=taille_image[0],             # Largeur de l'image du nuage
        height=taille_image[1],            # Hauteur de l'image du nuage
        max_words=200,                     # Nombre maximum de mots dans le nuage
        min_font_size=10,                  # Taille minimale des mots
        max_font_size=100,                 # Taille maximale des mots
        background_color="white",         # Couleur de fond
        contour_color="blue",            # Couleur du contour de la forme
        contour_width=12,                  # Largeur du contour
        relative_scaling=0,                # Pas de mise à l'échelle relative des mots
        colormap="viridis",               # Couleur des mots
        mask=masque,                       # Appliquer le masque
        mode="RGB",                       # Mode couleur
        stopwords=stopwords               # Liste des mots vides
    ).generate(" ".join(mots_en_espagnol))  # Générer le nuage de mots uniquement avec les mots en espagnol

    # Créer la figure avec les dimensions en pixels
    plt.figure(figsize=(taille_image[0] / 100, taille_image[1] / 100))  
    plt.imshow(wordcloud, interpolation="bilinear")
    plt.axis("off") 
    plt.title(f"Nuage de mots autour du mot : '{mot_cle}'")
    
    # Sauvegarder l'image du nuage de mots
    plt.savefig(output_path, format="png") 
    print(f"Le nuage de mots a été sauvegardé sous : {output_path}")
    
    # Afficher le nuage de mots
    plt.show()

def main():
    # Demander à l'utilisateur d'entrer le chemin du dossier et le mot clé
    dossier = input("Entrez le chemin du dossier contenant les fichiers txt : ")
    mot_cle = input("Entrez le mot clé pour le nuage de mots : ")
    image_mask_path = input("Entrez le chemin de l'image : ")
    output_path = input("Entrez le chemin où sauvegarder l'image  : ")
    largeur = int(input("Entrez la largeur de l'image du nuage de mots : "))
    hauteur = int(input("Entrez la hauteur de l'image du nuage de mots : "))

    # Demander les mots à ignorer
    mots_vides_input = input("Entrez les mots à ignorer, séparés par des espaces (laisser vide pour les mots vides standards) : ")
    mots_vides = set(mots_vides_input.lower().split())

    # Demander le dossier contenant les fichiers du dictionnaire espagnol
    dossier_dico = input("Entrez le chemin du dossier contenant les fichiers du dictionnaire espagnol : ")

    # Charger le dictionnaire des mots en espagnol à partir des fichiers
    mots_espagnols = charger_dictionnaire_espagnol(dossier_dico)
    
    # Extraire le texte de tous les fichiers txt dans le dossier
    texte = extraire_texte_du_dossier(dossier)
    
    # Créer et sauvegarder le nuage de mots
    creer_nuage_de_mots(texte, mot_cle, image_mask_path, taille_image=(largeur, hauteur), output_path=output_path, mots_vides=mots_vides, mots_espagnols=mots_espagnols)

if __name__ == "__main__":
    main()


# In[ ]:




