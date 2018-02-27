TimeStamp_ch <- function (ch0, ch1, ch2){
  
  ch0 <- data.frame(TimeStamp=ch0[,1], V1_ch0=ch0[,2], V2_ch0=ch0[,3])
  ch1 <- data.frame(V1_ch1=ch1[,2], V2_ch1=ch1[,3])
  ch2 <- data.frame(V1_ch2=ch2[,2], V2_ch2=ch2[,3])
  
  ch_ALL <- cbind(ch0, ch1, ch2)
                    
  ch_temp <- data.frame(TimeStamp=ch_ALL[1:nrow(ch_ALL), 1]+(ch_ALL[(1:nrow(ch_ALL))+1, 1]-ch_ALL[1:nrow(ch_ALL), 1])/2, 
                        V2_ch0=ch_ALL[,3], V2_ch1=ch_ALL[,5], V2_ch2=ch_ALL[,7])
  
  ch_ALL <- ch_ALL[-3]
  ch_ALL <- ch_ALL[-4]
  ch_ALL <- ch_ALL[-5]
  
  names(ch_ALL) <- c("TimeStamp", "V_ch0", "V_ch1", "V_ch2")
  names(ch_temp) <- c("TimeStamp", "V_ch0", "V_ch1", "V_ch2")
  ### On agrège les deux matrice en une
  ch_ALL <- rbind(ch_ALL, ch_temp)
  
  ### Puis on organise la matrice par TimeStamp croissant
  
  ch_ALL <- ch_ALL[order(ch_ALL$TimeStamp),]

  return(ch_ALL)
}

