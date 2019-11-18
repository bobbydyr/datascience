library("shiny")
library("ggplot2")
library("dplyr")
library("tidyr")
library("plotly")
library("tidyverse")
library("leaflet")
library("packcircles")
library("viridis")
library("ggiraph")

source("intro_and_summary.R")

df_2018 <- read.csv("data/df_2018.csv", stringsAsFactors = F)

server <- function(input, output){
  output$map <- renderLeaflet({
    df_modified <- df_2018 %>%
      mutate(people_hurt = INJURIES + SERIOUSINJURIES + FATALITIES,
             MONTH = month(mdy_hms(INCDTTM))) %>%
      filter(ROADCOND == input$road_condition_choice) %>%
      select(X, Y, INJURIES, SERIOUSINJURIES, FATALITIES, people_hurt, INCDTTM,
        LOCATION, MONTH)


    leaflet(data = df_modified) %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(lat = 47.6062, lng = -122.3321, zoom = 11) %>%
      addCircles(
        lat = ~Y, lng = ~X, stroke = FALSE,
        popup = ~ paste0(
          "On ", INCDTTM, ". ", "<br>", FATALITIES,
          " people were killed, and ", (SERIOUSINJURIES + INJURIES),
          " people got injured.", "<br>", "Location: ",
          LOCATION, "."
        ),
        color = ~people_hurt,
        radius = 100,
        fillOpacity = 0.2, fillColor = input$map_color
      ) %>%
      addTiles("Seattle Car Accident Distribution")
  })


  output$map2 <- renderLeaflet({
    df_modified2 <- df_2018 %>%
      mutate(people_hurt = INJURIES + SERIOUSINJURIES + FATALITIES,
             MONTH = month(mdy_hms(INCDTTM))) %>%
      filter(MONTH == input$map_month_choice) %>%
      select(
        X, Y, INJURIES, SERIOUSINJURIES, FATALITIES, people_hurt, INCDTTM,
        LOCATION, MONTH)


    leaflet(data = df_modified2) %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(lat = 47.6062, lng = -122.3321, zoom = 11) %>%
      addCircles(
        lat = ~Y, lng = ~X, stroke = FALSE,
        popup = ~ paste0(
          "On ", INCDTTM, ". ", "<br>", FATALITIES,
          " people were killed, and ", (SERIOUSINJURIES + INJURIES),
          " people got injured.", "<br>", "Location: ",
          LOCATION, "."
        ),
        color = ~people_hurt,
        radius = 100,
        fillOpacity = 0.2, fillColor = input$map_color
      ) %>%
      addTiles("Seattle Car Accident Distribution")
  })



  output$bar <- renderPlotly({


    # data frame
    time_counts <- df_2018 %>%
      select(PEDCOUNT, PEDCYLCOUNT, INCDTTM, PERSONCOUNT, INJURIES,
             FATALITIES) %>%
      mutate(time = sub("^\\S+\\s+", "", INCDTTM)) %>% # just time, no date
      # turns all time to military time
      mutate(time_only = format(strptime(time, "%I:%M:%S %p"), "%H")) %>%
      # morning 5am - 12pm, afternoon 12-5pm, evening 5-9pm, night 9pm - 4am
      mutate(part_of_day =
               ifelse(time_only %in% 5:12, "Morning",
                      ifelse(time_only %in% 12:17, "Afternoon",
                             ifelse(time_only %in% 17:21, "Evenining",
                                    "Night")))) %>%
      mutate(just_date = as.Date(INCDTTM, "%m/%d/%Y")) %>%
      mutate(Weekday = weekdays(just_date),
             Month = months(just_date),
             Collisions = 1)  %>%
      rename(Pedestrians = PEDCOUNT, # Renaming columns
             Cyclists = PEDCYLCOUNT,
             People = PERSONCOUNT,
             Injuries = INJURIES,
             Fatalities = FATALITIES) %>%
      select(-c(time_only, INCDTTM, time, just_date)) %>% # drop columns
      mutate(Month = factor(Month, levels = month.name[1:12]),
             part_of_day = factor(part_of_day, levels =
                                    c("Morning", "Afternoon",
                                      "Evenining", "Night")),
             Weekday = factor(Weekday, levels = c("Monday", "Tuesday",
                                                  "Wednesday", "Thursday",
                                                  "Friday", "Saturday",
                                                  "Sunday"))) %>%
      group_by_(input$bar_x_var) %>%
      summarise_if(is.numeric, sum)

    bar_title <- paste0(input$bar_y_var, " throughout ", input$bar_x_var)

    b_graph <- ggplot(time_counts) +
      geom_col(aes_string(x = input$bar_x_var, y = input$bar_y_var),
               fill = "white", color = "tomato3") +
      labs(title = bar_title) +
      theme(axis.text.x =
              element_text(size  = 10,
                           angle = 45,
                           hjust = 1,
                           vjust = 1))

    ggplotly(b_graph)
  })

  output$weather <- renderggiraph({
    # gather the information for the weather casualty circle packing
    weather_casualty_df <- df_2018 %>%
      select(INJURIES, SERIOUSINJURIES, FATALITIES, WEATHER) %>%
      group_by(WEATHER) %>%
      summarize(
        Injuries = sum(INJURIES),
        "Serious Injuries" = sum(SERIOUSINJURIES),
        Fatalities = sum(FATALITIES),
        "Total Injuries" = sum(
          sum(INJURIES) +
            sum(SERIOUSINJURIES)
        ),
        "Total Casualties" = sum(
          sum(INJURIES) +
            sum(SERIOUSINJURIES) +
            sum(FATALITIES)
        )
      )

    # merge unknown weather together
    for (i in 2:6) {
      weather_casualty_df[11, i] <- weather_casualty_df[11, i] +
        weather_casualty_df[1, i]
    }
    weather_casualty_df <- weather_casualty_df %>%
      filter(WEATHER != "")

    # keep only the information user selected and
    # transform the table for circle parking
    circle_table <- weather_casualty_df %>%
      select(WEATHER, input$casualty_type)
    circle_table <- circle_table %>%
      filter(circle_table[, 2] != 0)

    # make the circle packing

    # Generate the layout. This function return a dataframe with one line per
    # bubble.

    # Add a column with the text
    circle_table$text <- paste("Weather Condition: ", circle_table$WEATHER,
                               "\n", "Number of People:",
                              circle_table[[input$casualty_type]])

    # It gives its center (x and y) and its radius, proportional of the value
    packing <- circleProgressiveLayout(circle_table[[input$casualty_type]],
                                       sizetype = "area")

    packing_temp <- packing
    while (max(packing$radius) < 30){
      packing <- packing + packing_temp
    }

    # We can add these packing information to the initial data frame
    circle_table <- cbind(circle_table, packing)

    # The next step is to go from one center + a radius to the coordinates of
    # a circle that is drawn by a multitude of straight lines.
    dat.gg <- circleLayoutVertices(packing, npoints = 100)

    # Make the plot
    circle_packing <- ggplot() +
      geom_polygon_interactive(data = dat.gg, aes(x, y, group = id, fill = id,
                                                  tooltip =
                                                    circle_table$text[id],
                                                  data_id = id),
                               colour = "black", alpha = 0.6) +
      scale_fill_viridis() +
      geom_text(data = circle_table, aes(x, y, label = WEATHER),
                size = trunc(circle_table$radius / 3.95), color = "black") +
      ggtitle(paste0(input$casualty_type, " in Different Weather Conditions")) +
      theme_void() +
      theme(plot.title = element_text(hjust = 0.5),
            legend.position = "none", plot.margin = unit(c(0, 0, 0, 0), "cm")
      ) +
      coord_equal()

    circle_packing <- ggiraph(ggobj = circle_packing, width_svg = 5,
                           height_svg = 5)

    return(circle_packing)
  })

  # plots for summary plots page
  output$weather_sum <- renderPlotly(weather_g)
  output$road_condition_sum <- renderPlotly(road_condition_g)
  output$light_sum <- renderPlotly(light_g)
  output$collision_sum <- renderPlotly(collision_g)
  output$junction_sum <- renderPlotly(junction_g)
  output$address_sum <- renderPlotly(address_g)
}