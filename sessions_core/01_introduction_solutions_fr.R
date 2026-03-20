# SESSION INTRODUCTION 
# Auteur :  l'équipe Repicentre
# Date de création : 06/01/2025
# Last Update : 28/05/2025
# Description : Code modèle pour la session 1 (introduction à R et RStudio)
# -------------------------------------------------------------------------------------------------- 


# Types de données ---------------------------------------------------------------------------------------

# Obtenir le type d'un objet
class(28)  
class("Mandoul")


# Tester le type d'un objet
is.numeric(28)
is.numeric("Mandoul")
is.character("Mandoul")

is.numeric(TRUE)
is.character(TRUE)
is.logical(FALSE)



# Créer un objet -------------------------------------------------------------------------------

# On crée des objets avec l'opérateur `<-`
region <- "Mandoul"

# On les met à jour de la même manière
region <- "Moyen Chari"



# Vecteurs atomiques -----------------------------------------------------------------------------------


# Vector de taille un; c'est un vecteur numérique car il contient un entier (28)
cas <- 28

# Les vecteurs peuvent contenir plusieurs valeurs
cas <- c(2, 5, 8, 0, 4)

# Les vecteurs peuvent aussi contenir du texte
region <- c("Mandoul", "Moyen-Chari", "Logone Oriental",
            "Tibesti", "Logone Occidental")



# [les crochets] permettent d'accéder au contenu d'un vecteur à l'aide de l'index la position)
region[3]     # extrait la troisième valeur
region[1:2]   # extrait les premières et deuxièmes valeurs


# Data frames ---------------------------------------------------------------------------------------

# Créer un data frame
data_cas <- data.frame(
  cas = c(2, 5, 8, 0, 4),
  region = c("Mandoul", "Sud Kivu", "Kasai oriental", 
             "Kasai", "Haut Katanga"))


# On peut aussi créer le data frame à partir de vecteurs déjà existants et de MEME TAILLE
data_cas <- data.frame(cas, region) 


# Quelques fonctions pour étudier la structure d'un data frame
str(iris)      # structure, et type de chaque colonne
dim(iris)      # dimensions, nombre de lignes et de colonnes
nrow(iris)     # nombre de lignes
ncol(iris)     # nombre de colonnes
names(iris)    # noms des colonnes


# les data frames sont indexés à l'aides de crochets, avec la syntaxe [lignes, colonnes]
data_cas[3, "region"]  # on peut spécifier les colonnes par leur noms
data_cas[3, 2]         # ou par leur index numérique

# on peut extraires plusieurs lignes ou colonnes d'un coup
data_cas[2:3, "cas"]
data_cas[2:3, 1]



# Fonctions ----------------------------------------------------------------------------------------

# les fonctions sont utilisés pour faire des choses ou calculs
sum(cas)           # calcule la somme des valeurs du vecteur cas
min(c(2, 0, 6))    # trouve le minimum dans un vecteur de valeurs (non nommé)

