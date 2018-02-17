## Traitement des lux
lux <- function (ch){
  
  min <- filter(ch, TimeStamp < 6*10^8) # Mean 1 minute
  U0<-mean(min[,2]) 
  
  a=3000/(3.3-U0) # Pente
  b=-a*U0
  
  lux <- data.frame(TS=ch[,1],LUX1=a*ch[,2]+b, LUX2=a*ch[,3]+b) ## Application ax +b

  return(lux)
}