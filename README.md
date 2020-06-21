# Twenty Years of Flooding in Houston


This project explores FEMA flood claims data taken from https://www.fema.gov/media-library/assets/documents/180374.

We can see that spikes in FEMA flood claims correlate with major flood events in Houston.

![Flood Claims](./plots/claims_by_date.png) 

Because FEMA provides annonymized data we can view claims by:

* Zip code
* Latitude and longitude (rounded to one decimal)
* Census Tract

Census tract is the most discrete level of detail available. We can plot claim counts by census tract for various storm events, to see which areas were hardest-hit.

![Flood Claims - Storm Allison](./plots/Map_Allison.png) 

![Flood Claims - Hurricaine Ike](./plots/Map_Ike.png) 

![Flood Claims - Hurricaine Harvey](./plots/Map_Harvey.png) 