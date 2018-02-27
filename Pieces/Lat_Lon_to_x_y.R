#convert LAT/LONG to X/Y
traitementGPS=function(GPS_ch){
  #Let's import only TimeStamp, Latitude and Longitude from GPS file
  GPS <- data.frame(lon=GPS_ch[,2], lat=GPS_ch[,2])
  coordinates(GPS) <- c("lon", "lat")
  proj4string(GPS) <- CRS("+proj=tmerc +lat_0=0 +lon_0=30 +k=1 +x_0=500000 +y_0=0 +ellps=krass +units=m +no_defs") # WGS 84
  CRS.new <- CRS("+proj=tmerc +lat_0=0 +lon_0=30 +k=1 +x_0=500000 +y_0=0 +ellps=krass +units=m +no_defs ")
  d.ch1903 <- spTransform(GPS, CRS.new)
  return (d.ch1903)
}