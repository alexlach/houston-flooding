library(data.table)
library(lubridate)
library(sf)
library(ggplot2)
library(scales)

# uses flood claim data from https://www.fema.gov/media-library/assets/documents/180374
#claims = fread("claims.csv", integer64 = 'character')
#claims = subset(claims, claims$latitude < 30.132032 & claims$latitude > 29.565135 & 
#                  claims$longitude < -95.105237 & claims$longitude > -95.846073)
#fwrite(claims, file = "/Users/alexanderlach/Downloads/FIMA_NFIP_Redacted_Claims_Data_Set/claims_houston.csv")  #export houston claims (for smaller data)

claims = fread("claims_houston.csv", integer64 = 'character')

claims = subset(claims, claims$amountpaidonbuildingclaim > 5000)  # limit to claims with significant building damage
claims$dateofloss = ymd(claims$dateofloss)
shape_highway = st_read("shapefiles/highway/COH_FREEWAY.shp")
shape_water = st_read("shapefiles/water/COH_WATERWAY.shp")
shape_census = st_read("shapefiles/censustract/tl_2019_48_tract.shp")
shape_census = subset(shape_census, shape_census$GEOID %in% claims$censustract)

plotDateLimit = function(date_min = ymd("1950-01-01"), date_max = ymd("2100-01-01"), title = "Flood Claim Count by Census Tract"){
  claims = subset(claims, claims$dateofloss > date_min & claims$dateofloss < date_max)
  claim_by_census = as.data.frame(table(claims$censustract))  # generate table of claim count by census tract
  names(claim_by_census) = c("GEOID", "CLAIM_COUNT")
  shape_census_merged = merge(shape_census, claim_by_census)
  ggplot() +
    geom_sf(data=shape_census_merged, size=0.3, color="white", aes(fill=CLAIM_COUNT)) +
    geom_sf(data=shape_highway, alpha=0.7) + 
    geom_sf(data=shape_water, color="blue", alpha=0.5) + 
    ggtitle(title) + theme_bw() + theme(panel.grid.major=element_line("white")) + 
    scale_fill_gradient(low="#eeefff", high="#104E8B", na.value="grey70") +
    xlim(-95.70, -95.10) + ylim(29.56, 30.02)
}

ggplot(claims, aes(as.POSIXct(dateofloss), ..count..)) + 
  geom_histogram(bins = 60) +
  ggtitle("Flood Claim Count by Date") + 
  theme_bw() + xlab(NULL) + ylab(NULL) + 
  geom_vline(xintercept=as.numeric(as.POSIXct("2001-06-07"))) +
  annotate("text", x=as.POSIXct("2001-06-07"), y=35000, label="\nStorm Allison", size=3, angle=90) + 
  geom_vline(xintercept = as.numeric(as.POSIXct("2008-09-13"))) +
  annotate("text", x=as.POSIXct("2008-09-13"), y=35000, label="\nHurricaine Ike", size=3, angle=90) + 
  geom_vline(xintercept = as.numeric(as.POSIXct("2015-05-25"))) +
  annotate("text", x=as.POSIXct("2015-05-25"), y=35000, label="\nMemorial Day Floods", size=3, angle=90) + 
  geom_vline(xintercept = as.numeric(as.POSIXct("2016-04-17"))) +
  annotate("text", x=as.POSIXct("2016-04-17"), y=35000, label="\nTax Day Floods", size=3, angle=90) + 
  geom_vline(xintercept = as.numeric(as.POSIXct("2017-08-27"))) +
  annotate("text", x=as.POSIXct("2017-08-27"), y=35000, label="\nHurricaine Harvey", size=3, angle=90) + 
  scale_x_datetime(labels = date_format("%Y-%b"), limits = c(as.POSIXct("2000-01-01"), as.POSIXct("2019-12-01")) )
ggsave("plots/claims_by_date.png", width = 10, height = 6, units = "in")

plotDateLimit(date_min = ymd("2000-01-01"), title = "Flood Claim Count by Census Tract (Since January 2000)")
ggsave("plots/Map_All.png", width = 10, height = 8, units = "in")
plotDateLimit(date_min = ymd("2001-05-15"), date_max = ymd("2017-06-15"), title = "Flood Claim Count by Census Tract (Allison)")
ggsave("plots/Map_Allison.png", width = 10, height = 8, units = "in")
plotDateLimit(date_min = ymd("2008-09-01"), date_max = ymd("2008-10-01"), title = "Flood Claim Count by Census Tract (Ike)")
ggsave("plots/Map_Ike.png", width = 10, height = 8, units = "in")
plotDateLimit(date_min = ymd("2015-05-01"), date_max = ymd("2015-06-15"), title = "Flood Claim Count by Census Tract (Memorial Day)")
ggsave("plots/Map_Memorial.png", width = 10, height = 8, units = "in")
plotDateLimit(date_min = ymd("2016-04-01"), date_max = ymd("2016-05-01"), title = "Flood Claim Count by Census Tract (Tax Day)")
ggsave("plots/Map_Tax.png", width = 10, height = 8, units = "in")
plotDateLimit(date_min = ymd("2017-08-15"), date_max = ymd("2017-09-15"), title = "Flood Claim Count by Census Tract (Harvey)")
ggsave("plots/Map_Harvey.png", width = 10, height = 8, units = "in")
