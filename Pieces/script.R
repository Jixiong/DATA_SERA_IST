# Chargement des librairies 
library("plyr") 
library("dplyr")
library("data.table")
library("zoo")
library("rgdal")
library("ggplot2")
library("ggmap")
library("oce")


# On récupère les données des fichier csv
GPS <- fread("DATA_Debut/GPS.csv", header = FALSE, sep=";")
ch0 <- fread("DATA_Debut/ch0.csv", header = FALSE, sep=";")
ch1 <- fread("DATA_Debut/ch1.csv", header = FALSE, sep=";")
ch2 <- fread("DATA_Debut/ch2.csv", header = FALSE, sep=";")

# Un peu de tri dans les colonnes du fichier GPS
GPS <- data.frame(TimeStamp=GPS[,1], lat=GPS[,3], lon=GPS[,4])

# Renommage des data.frame
names(ch0) <- c("TimeStamp", "V1_ch0", "V2_ch0")
names(ch1) <- c("TimeStamp", "V1_ch1", "V2_ch1")
names(ch2) <- c("TimeStamp", "V1_ch2", "V2_ch2")
names(GPS) <- c("TimeStamp", "lat", "lon")

# Traitement des lux
## Lien vers la fonction 
source("luxmetre.R")
## Appel de la fonction pour chaque data.frame
lux_ch0 <- lux(ch0)
lux_ch1 <- lux(ch1)
lux_ch2 <- lux(ch2)
## Mettre les valeurs retourné à la place des anciennes
ch0[,2:3] <- lux_ch0[,2:3] 
ch1[,2:3] <- lux_ch1[,2:3] 
ch2[,2:3] <- lux_ch2[,2:3]

# Traitement des TimeStamp
## Lien vers la fonction 
source("TimeStamp_ch.R")
## Appel de la fonction pour chaque data.frame
ch <- TimeStamp_ch(ch0, ch1, ch2)
## Lien vers la fonction
source("TimeStamp_GPS.R")
## Appel de la fonction pour la data.frame GPS
GPS <- TimeStamp(GPS)
### Réunification des deux data.frame traités 
DATA_GPS_CH <- rbind.fill(GPS, ch)
### Réorganiser dans l'ordre de TImeStamp
DATA_GPS_CH <- DATA_GPS_CH[order(DATA_GPS_CH$TimeStamp),]
### Approximation de valeurs intermediaires pour les capteurs correspondante aux données GPS réelles 
#### Tri
approx_ch <- DATA_GPS_CH[,c("TimeStamp", "V_ch0", "V_ch1", "V_ch2")]
#### Aproximation
approx_ch <- na.approx(approx_ch)
#### Recréer le résulatat du calcul en data.frame
approx_ch <- as.data.frame(approx_ch)
#### Suppression du TimeStamp
approx_ch <- approx_ch[,-1] 

## Réunir les données
### Tri des données non-utile
DATA_GPS_CH <- DATA_GPS_CH[,-(4:6)]
### Réunification
DATA_GPS_CH_Link <- cbind(DATA_GPS_CH, approx_ch)
### Suppression du TimeStamp
DATA_GPS_CH_Link <- DATA_GPS_CH_Link[,-1]
### Suppression de toute les données non liées (NA)
DATA_GPS_CH_Link <- na.omit(DATA_GPS_CH_Link)
### Suppression de l'initialisation de GPS
DATA_GPS_CH_Link <- DATA_GPS_CH_Link[DATA_GPS_CH_Link[,1] > 41.036,]
### Aggregation des Valeurs GPS identique, et moyenne des données de capteurs correspondante
DATA_GPS_CH_Link <- aggregate(cbind(V_ch0, V_ch1, V_ch2) ~ lat+lon, DATA_GPS_CH_Link, FUN=mean)

## Création de fichier indépendant 
GPS_ch0 <- DATA_GPS_CH_Link[,c("lat", "lon", "V_ch0")]
GPS_ch1 <- DATA_GPS_CH_Link[,c("lat", "lon", "V_ch1")]
GPS_ch2 <- DATA_GPS_CH_Link[,c("lat", "lon", "V_ch2")]

## Suppression des données de capteur inferieur à 0 correspondante au noir
GPS_ch0 <- GPS_ch0[GPS_ch0[,3]>0,]
GPS_ch1 <- GPS_ch1[GPS_ch1[,3]>0,]
GPS_ch2 <- GPS_ch2[GPS_ch2[,3]>0,]

## Ici test de projection
### Projection dans le plan x y depuis les données de latitude et longitude
xy_ch0 <- lonlat2map(GPS_ch0[,2], GPS_ch0[,1], projection = "+proj=tmerc")
xy_ch0 <- data.frame(xy_ch0)
xy_ch1 <- lonlat2map(GPS_ch1[,2], GPS_ch1[,1], projection = "+proj=tmerc")
xy_ch1 <- data.frame(xy_ch1)
xy_ch2 <- lonlat2map(GPS_ch2[,2], GPS_ch2[,1], projection = "+proj=tmerc")
xy_ch2 <- data.frame(xy_ch2)

### Projection en latitude et longitude des données du plan x y 
xy_ch0 <- map2lonlat(xy_ch0)
xy_ch1 <- map2lonlat(xy_ch1)

xy_ch0 <- data.frame(xy_ch0)
xy_ch1 <- data.frame(xy_ch1)
