# Road conditions vs. fatalities chart

pie_chart_fun <- function(traffic_df) {
  # calculate the serious injuries and fatalities in different
  # weather conditions
  weather_fatality_df <- traffic_df %>%
    select(FATALITIES, WEATHER) %>%
    group_by(WEATHER) %>%
    summarize(total_fatalities = sum(FATALITIES))

  # make a pie chart of weather condition and fatalities
  # delete weather conditions in which fatality is zero
  weather_fatality_chart_df <- weather_fatality_df %>%
    filter(total_fatalities != 0)

  # name unknown weather as "Unknown"
  weather_fatality_chart_df$WEATHER[1] <- "Unknown"

  # Create a basic bar
  pie <- ggplot(
    weather_fatality_chart_df,
    aes(x = "", y = total_fatalities, fill = WEATHER)
  ) +
    geom_bar(stat = "identity", width = 1)

  # Convert to pie (polar coordinates) and add labels
  value <- weather_fatality_chart_df$total_fatalities /
    sum(weather_fatality_chart_df$total_fatalities)
  pie <- pie +
    coord_polar("y", start = 0) +
    geom_text(aes(label = paste0(round(value * 100), "%")),
      position = position_stack(vjust = 0.5), size = 3
    )

  # Remove labels and add title
  pie <- pie +
    labs(
      x = NULL, y = NULL, fill = NULL,
      title = "Fatalities vs Weather Conditions"
    )

  # Tidy up the theme
  pie <- pie +
    theme_classic() +
    theme(
      axis.line = element_blank(),
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      plot.title = element_text(size = 15)
    )

  # return pie chart
  pie
}
