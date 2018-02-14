data_ch1 <- read.csv("AllDatas_20160329_205341_ch1_output.csv", header = FALSE, sep = ";")

nbr <- 0
j <- 1 
i <-1
pommeau <- 0

vecteur_moy <- matrix(rep(0, 2*1157498), nrow= 1157498, ncol = 2)

while (i <= nrow(data_ch1)){
  if (data_ch1[i,1] < data_GPS_temp[j,11]){
    
    nbr <- nbr+1
    vecteur_moy[j,1] <- vecteur_moy[j,1] + data_ch1[i,2] 
    vecteur_moy[j,2] <- vecteur_moy[j,2] + data_ch1[i,3]
  } else if(nbr > 0){
    
    vecteur_moy[j,1] <- vecteur_moy[j,1] / nbr
    vecteur_moy[j,2] <- vecteur_moy[j,2] / nbr
    nbr <- 0
    j <- j+1
    i <- i-1
  } else {
    j <- j+1
    i <- i-1
  }
  i <- i+1
}

GPS_ch1 <- cbind(GPS_ch0, vecteur_moy)

names(GPS_ch1) <- c("TIMESTAMP", "Heure_GPS","Latitude","Longitude", "Nbr_Satellites","Precision","altitude", "Vitesse_H","Vitesse_V", "ch0_V1","ch0_V2", "ch1_V1","ch1_V2")

