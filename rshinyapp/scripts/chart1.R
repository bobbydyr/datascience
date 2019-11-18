# map of seattle collisions

# Function to return the map.
map_fun <- function(df) {
  # Select the data that we want.
  data <- df %>%
    mutate(year = year(INCDATE)) %>%
    filter(!is.na(X), !is.na(WEATHER)) %>%
    select(X, Y, FATALITIES, INJURIES,
           SERIOUSINJURIES, INCDATE, WEATHER, ROADCOND)
  # Create the map.
  map <- qmplot(X, Y,
    data = data, geom = "blank",
    zoom = 12, maptype = "toner-background",
    darken = .7, legend = "topleft"
  ) +
    stat_density_2d(aes(fill = ..level..),
                    geom = "polygon",
                    alpha = .3, color = NA) +
    scale_fill_gradient2("Accident\nPropensity",
      low = "white",
      mid = "yellow", high = "red", midpoint = 70
    ) +
    labs(title = "Seattle Traffic Accident Propensity")

  map
}