library("plyr") 
library("dplyr")
library("data.table")
library("zoo")
library("rgdal")
library("ggplot2")
library("ggmap")

GPS <- fread("DATA_Debut/GPS.csv", header = FALSE, sep=";")
ch0 <- fread("DATA_Debut/ch0.csv", header = FALSE, sep=";")
ch1 <- fread("DATA_Debut/ch1.csv", header = FALSE, sep=";")
ch2 <- fread("DATA_Debut/ch2.csv", header = FALSE, sep=";")

GPS <- data.frame(TimeStamp=GPS[,1], lat=GPS[,3], lon=GPS[,4])

names(ch0) <- c("TimeStamp", "V1_ch0", "V2_ch0")
names(ch1) <- c("TimeStamp", "V1_ch1", "V2_ch1")
names(ch2) <- c("TimeStamp", "V1_ch2", "V2_ch2")
names(GPS) <- c("TimeStamp", "lat", "lon")

source("TimeStamp_ch.R")

ch <- TimeStamp_ch(ch0, ch1, ch2)

source("TimeStamp_GPS.R")

GPS <- TimeStamp(GPS)

DATA_GPS_CH <- rbind.fill(GPS, ch)

DATA_GPS_CH <- DATA_GPS_CH[order(DATA_GPS_CH$TimeStamp),]

approx_ch <- DATA_GPS_CH[,c("TimeStamp", "V_ch0", "V_ch1", "V_ch2")]
approx_ch <- na.approx(approx_ch)
approx_ch <- as.data.frame(approx_ch)
approx_ch <- approx_ch[,-1] 

DATA_GPS_CH <- DATA_GPS_CH[,-(4:6)]
DATA_GPS_CH_Link <- cbind(DATA_GPS_CH, approx_ch)
DATA_GPS_CH_Link <- DATA_GPS_CH_Link[,-1]
DATA_GPS_CH_Link <- na.omit(DATA_GPS_CH_Link)
DATA_GPS_CH_Link <- DATA_GPS_CH_Link[DATA_GPS_CH_Link[,1] > 41.036,]

DATA_GPS_CH_Link <- aggregate(cbind(V_ch0, V_ch1, V_ch2) ~ lat+lon, DATA_GPS_CH_Link, FUN=mean)

GPS_ch0 <- DATA_GPS_CH_Link[,c("lat", "lon", "V_ch0")]
GPS_ch1 <- DATA_GPS_CH_Link[,c("lat", "lon", "V_ch1")]
GPS_ch2 <- DATA_GPS_CH_Link[,c("lat", "lon", "V_ch2")]

source("Lat_Lon_to_x_y.R")

GPS_ch0_m <- traitementGPS(GPS_ch0)
