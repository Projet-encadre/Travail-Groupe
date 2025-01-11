# Travail en Groupe
## PPE1-2024

### Membres de l'Équipe
Voici les membres du groupe et leurs profils GitHub :

- **CHENG Dingding** (Sorbonne-Nouvelle) - [https://github.com/GoddessUni](https://github.com/GoddessUni)
- **DA Silva Jean-Charles** (Paris-Nanterre) - [https://github.com/jcharlesDS](https://github.com/jcharlesDS)
- **WANG Xiaobo** (Inalco) - [https://github.com/Xiaobo33](https://github.com/Xiaobo33)
- **KULIKOVA Natalia** (Inalco) - [https://github.com/NATaaLiAAK](https://github.com/NATaaLiAAK)

### Description du Projet

Ce projet fait partie du sujet "La Vie Multilingue des Mots" et vise à analyser le mot "racine" dans quatre langues : français, espagnol, anglais et chinois. Pour chaque langue, 50 liens de sites web sont utilisés comme corpus de base pour l'analyse.

Le projet comprend plusieurs fichiers et scripts destinés à réaliser des calculs textométriques et des analyses sur les corpus textuels. En particulier, il inclut des fichiers pour PALS (Python Autonomous Lafon Specificity Scripts), qui permettent de calculer la spécificité de Lafon. Cette mesure évalue la spécificité d'une forme dans une portion de corpus donnée, qu'il s'agisse d'un partitionnement général (par exemple, par chapitres ou livres) ou plus spécifique (autour d'un mot particulier).

Les principaux scripts inclus sont :

- `partition.py` : Pour effectuer des calculs sur des partitions générales du corpus.

- `cooccurrents.py` : Pour analyser les cooccurrences autour du mot cible. Ce script est principalement utilisé pour illustrer les analyses sur les cooccurrences.

Ces scripts permettent ainsi de réaliser des analyses textométriques simples et configurables sur le corpus. L’utilisation d'expressions régulières permet de matcher différentes formes graphiques des mots.

L’objectif est de créer un fichier pour chaque langue analysée, afin d'effectuer des analyses quantitatives. Ces analyses serviront ensuite à identifier des éléments notables, qui seront utilisés pour une analyse qualitative plus approfondie.

#### Exercice 2 : Travail sur les dumps textuels

Avant de lancer les scripts, il est nécessaire de créer un dossier pals. Ensuite, un script appelé `make_pals_corpus.sh` doit être créé. Ce script prend en argument un dossier et un nom de base (qui correspond au nom du fichier URL sans son extension, tel que **lang1** ou **lang2** dans l'exemple donné).

##### Objectifs du script :

- Le script doit créer un fichier au format attendu par PALS, en suivant la structure définie dans l'Exercice 1.
- Il devra itérer sur les fichiers dumps (un par URL), prétraiter les données, et les écrire dans la sortie standard. Une redirection pourra être utilisée pour sauvegarder ces fichiers.
- Par exemple, si le nom de base est **lang1**, le fichier généré devra être nommé `dump-lang1.txt` et être placé dans le dossier `pals`.

##### Points à considérer :

**Tokenisation** : Cette étape doit être réalisée avant d'exécuter le script. La tokenisation est importante car elle affecte les résultats finaux. Le script devra pouvoir prendre en entrée des données déjà tokenisées et effectuer les analyses nécessaires à la suite de cette étape.

#### Exercice 3 : Travail sur les contextes

Le troisième exercice consiste à appliquer les mêmes manipulations que dans l'Exercice 2, mais cette fois-ci sur les `fichiers de contexte`. Le travail consiste à ajouter la gestion des fichiers de contexte dans le script `make_pals_corpus.sh`.

##### Objectifs du script modifié :

- Les fichiers générés à partir des données de contexte devront être nommés sous la forme `contexte-lang1.txt`.
- Le fichier final, après traitement de tous les contextes, devra être nommé `contexte.txt` et être placé dans le dossier `pals`.

Ce travail sur les contextes permet d'élargir l'analyse aux informations contextuelles des mots, en ajoutant de la richesse aux résultats finaux.

#### Création de Nuages de Mots

Après avoir préparé les fichiers pour chaque langue et extrait les données pertinentes, il sera nécessaire de créer des **nuages de mots** pour chaque langue. Ces nuages de mots permettent de visualiser les termes les plus fréquents dans le corpus, offrant ainsi une première analyse visuelle des données. Pour cela, nous utilisons la bibliothèque WordCloud en Python.





