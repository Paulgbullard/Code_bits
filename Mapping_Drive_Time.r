library(osrm)
library(PostcodesioR)
library(leaflet)

loc <- postcode_lookup("ME3 7LH")

iso <- osrmIsochrone(loc = c(loc$longitude,loc$latitude), breaks = seq(from = 0, to = 30, by = 5))

iso@data$drive_times <- factor(paste(iso@data$min, "to", iso@data$max, "min"))

factpal <- colorFactor(rev(heat.colors(5)), iso@data$drive_times)

leaflet() %>% 
  addProviderTiles("CartoDB.Positron", group="Greyscale") %>% 
  setView(home$longitude, home$latitude, zoom = 11) %>% 
  addPolygons(fill = TRUE, stroke = TRUE, color = "black",
              fillColor = ~factpal(iso@data$drive_times),
              weight = 0.5, fillOpacity = 0.2,
              data = iso, popup = iso@data$drive_times,
              group = "Drive Time") %>% 
  addLegend("bottomright", pal = factpal, values = iso@data$drive_time, title = "Drive Time")
