import os
from wordcloud import WordCloud
import matplotlib.pyplot as plt
import chardet
import re

# Chemin vers le dossier contenant les fichiers texte
texts_folder = "../dumps-text"

# Récupérer le contenu des fichiers .txt
all_text = ""
for filename in os.listdir(texts_folder):
    file_path = os.path.join(texts_folder, filename)
    if os.path.isfile(file_path) and filename.endswith(".txt"):
        try:
            # Détection de l'encodage avec chardet
            with open(file_path, 'rb') as file:
                raw_data = file.read()
                result = chardet.detect(raw_data)
                encoding = result['encoding']
            
            # Lecture du fichier avec l'encodage détecté
            with open(file_path, 'r', encoding=encoding) as file:
                file_content = file.read()
                all_text += file_content + " "
        
        except Exception as e:
            print(f"Erreur lors de la lecture du fichier {filename} avec l'encodage {encoding}: {e}")

# Vérifier si des textes ont été récupérés
if not all_text.strip():
    raise ValueError("Aucun texte n'a été récupéré des fichiers. Vérifiez le dossier 'dumps-text'.")

# Extraire les mots autour de "racine" (fenêtre de 5 mots avant/après)
window_size = 5
words = all_text.split()
racine_related_words = []

for i, word in enumerate(words):
    if word.lower() == "racine":  # On cherche le mot exact "racine"
        start = max(0, i - window_size)
        end = min(len(words), i + window_size + 1)
        racine_related_words.extend(words[start:end])

# Si aucun mot n'est trouvé
if not racine_related_words:
    raise ValueError("Aucun mot trouvé autour de 'racine'.")

# Créer le nuage de mots
wordcloud = WordCloud(
    width=800,
    height=400,
    background_color="black",
    colormap="autumn"
).generate(" ".join(racine_related_words))

# Afficher et sauvegarder le nuage de mots
plt.figure(figsize=(10, 5))
plt.imshow(wordcloud, interpolation="bilinear")
plt.axis("off")
plt.title("Nuage de mots autour de 'racine'")
plt.show()

# Sauvegarde dans le fichier
output_path = "../wordcloud/nuage_racine.png"
os.makedirs(os.path.dirname(output_path), exist_ok=True)
wordcloud.to_file(output_path)
print(f"Nuage de mots sauvegardé dans {output_path}")
