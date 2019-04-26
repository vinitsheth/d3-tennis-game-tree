require(maps)
library(maps)
library(tools)
library(ggplot2)
library(rgeos)
library(dplyr)
require(rgdal)
library(maptools)

map('county', 'arizona', fill = TRUE, col = palette())
az_county_data <- map_data("county")

#read shape file
states.shp <-readOGR(dsn="2012election", layer = "elpo12p010g")

#taking subset for arizona counties
az_election_results<-subset(states.shp,STATE == "AZ")
az_county_data<-subset(az_county_data,region=="arizona")
az_county_data$subregion<-toTitleCase(az_county_data$subregion)

mapped_data<-merge(az_county_data, az_election_results, by.y = "COUNTY", by.x = "subregion")
mapped_data

#plot
ggplot(mapped_data,aes(long,lat,group=group.x)) + 
  geom_polygon(aes(fill=WINNER)) + 
  geom_polygon(data=mapped_data,colour='white',fill=NA)
