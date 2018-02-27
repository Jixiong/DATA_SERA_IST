vecteur_interval <- seq(1, (nrow(data_GPS)-2))
###vecteur_gauche <- 1:nrow(data_GPS)
###vecteur_droite <- 1:nrow(data_GPS)


for (a in 1:nrow(data_GPS)-1)
  vecteur_interval[a] <- (data_GPS[a, 1] + data_GPS[a+1, 1])/2


interval_gauche <- c(0, vecteur_interval)

interval_droite <- c(vecteur_interval, Inf)
                     
data_GPS_temp <- cbind(data_GPS, interval_gauche, interval_droite)

names(data_GPS_temp) <- c("TIMESTAMP", "Heure_GPS","Latitude","Longitude", "Nbr_Satellites","Precision","altitude", "Vitesse_H","Vitesse_V", "Intervale_Gauche","Intervale_Droite")