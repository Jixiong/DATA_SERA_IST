##############################################################################################################################################################
#                                                                                                                                                            #
#                                               Fonction qui créer un TimeStamp intermediaraire  pour chacune des mesures                                    # 
#                                                                                                                                                            #        
##############################################################################################################################################################

TimeStamp <- function (GPS_data){
  
  ### Sélection des données TimeStamp, Latitude et longitude de la matrice attribut dans la matrice data
  data <- data.frame(TimeStamp=GPS_data[,1], lat=GPS_data[,2], lon=GPS_data[,3])
  
  ### Creation d'une matrice temporaire data1
  data1 <- data.frame(TimeStamp=data[,1], lat=data[,2], lon=data[,3])
  
  ### Ici, on créer les valeurs intermediares
  ### Le TimeStamp, la Latitude et la longitude sont créer chacun d'entre eux à base de la moyenne de ((i+1)-i)2
  data2 <- data.frame(TimeStamp=data[1:nrow(data), 1]+(data[(1:nrow(data))+1, 1]-data[1:nrow(data), 1])/2, lat=data[1:nrow(data), 2]
                      +(data[(1:nrow(data))+1, 2]-data[1:nrow(data), 2])/2, lon=data[1:nrow(data), 3]+(data[(1:nrow(data))+1, 3]-data[1:nrow(data), 3])/2)
  
  ### On agrège les deux matrice en une
  timeStamp_Data <- rbind(data1,data2)
  
  ### Puis on organise la matrice par TimeStamp croissant
  
  timeStamp_Data <- timeStamp_Data[order(timeStamp_Data$TimeStamp),]
  
  ### Enfin la fonction renvoie la matrice
  return(timeStamp_Data)
}

