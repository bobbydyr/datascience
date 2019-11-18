library(plotly)
library(dplyr)
library(stringr)

df_2018 <- read.csv("./data/df_2018.csv", stringsAsFactors = F)

# create summary information of certain column from given dataframe
get_df <- function(df, colname) {
  result <- df %>%
  filter( (!!as.symbol(colname)) != "") %>%
  group_by( (!!as.symbol(colname))) %>%
  summarise(Count = n())

  # change the order
  result[[colname]] <- factor(
    result[[colname]],
    levels = unique(result[[colname]])[order(result[["Count"]],
                                              decreasing = T)]
  )
  return(result)
}

# create a barplot of given dataframe
get_g <- function(df, colname, title, color) {
  result <- plot_ly(df, x = as.formula(paste0("~", colname)),
                    y = ~Count, type = "bar", color = I(color)) %>%
    layout(xaxis = list(title = ""), yaxis = list(title = "Total Cases"),
           title = title)
  return(result)
}

weather_df <- get_df(df_2018, "WEATHER")
weather_g <- get_g(weather_df, "WEATHER", "Weather", "#ffa500")

road_condition_df <- get_df(df_2018, "ROADCOND")
road_condition_g <-
  get_g(road_condition_df, "ROADCOND", "Road Conditions", "#ffe8b0")

light_df <- get_df(df_2018, "LIGHTCOND")
light_g <-
  get_g(light_df, "LIGHTCOND", "Light Conditions", "#ffacd9")

collision_df <- get_df(df_2018, "COLLISIONTYPE")
collision_g <-
  get_g(collision_df, "COLLISIONTYPE", "Collision Types", "#b5d8f6")

junction_df <- get_df(df_2018, "JUNCTIONTYPE")
junction_g <-
  get_g(junction_df, "JUNCTIONTYPE", "Junction Types", "#c0c5ce")

address_df <- get_df(df_2018, "ADDRTYPE")
address_g <-
  get_g(address_df, "ADDRTYPE", "Address Types", "#7647a2")


intro_panel <- tabPanel(
  "Introduction",
  includeCSS("style.css"),
  div(
    class = "main",
    h2("Introduction", class = "tab-title"),
    p("This project is a research of collisions happened in Seattle in 2018.
    According to the news from The Seattle Times, Seattle traffic deaths
    and injuries down only slightly in 2018 compared to previous year.
    Most of the fatalities were pedestrians. However, Seattle Department
    of Transportation’s Vision Zero goal is to end traffic deaths and serious
    injuries on city streets in Seattle by 2030. Vision Zero is an international
    traffic-safety program started in Sweden and adopted by Seattle in 2015.
    The result of traffic fatalities and injuries in 2018 leaves the
    city far from meeting its goal."),
    p("Based on our daily experience, traffic conditions
    Seattle is not satisfying, especially in peak period of a day.
    For example, collisions and congestions
    often happen in Interstate 5. In addition, various weather in Seattle might
    increase the probability of collisions."),
    tags$figure(
      img(
        src =
"http://seattletimes.wpengine.netdna-cdn.com/today/files/2014/10/carcrash2.jpg",
        class = "image"
        ),
      tags$figcaption("Part of the scene of a multi-car crash
                      Friday afternoon on Rainier Avenue South in Seattle.")
    ),
    p("In order to know more detailed information about
    collisions such as locations, time and weather conditions,
    we find the data of collisions in 2018 collected
    from Seattle GSI. The data contains 40 variables in each specific collision
    such as weather, if bicycles were present, fatalities, and location."),
    a("Data Source", href = "https://data.seattle.gov/widgets/vac5-r8kk")
  )
)

summary_plots_panel <- tabPanel(
  "Summary Plots",
  div(
    class = "main",
    h2("Summary Information", class = "tab-title"),
    div(
      class = "plots",
      plotlyOutput("weather_sum"),
      plotlyOutput("road_condition_sum"),
      plotlyOutput("light_sum"),
      plotlyOutput("collision_sum"),
      plotlyOutput("junction_sum"),
      plotlyOutput("address_sum")
    )
  )
)

summary_info_panel <- tabPanel(
  "Summary Information",
  div(
    class = "main",
    h2("Conclusion", class = "tab-title"),
    tags$ol(
      class = "con-list",
      tags$li("Throught the analysis of time there was only one surpising
              pattern, that both afternoon and evening had the much higher
              numbers of involvment over all 6 factors. Other than that there
              was no other patterns across either weekdays or months. However
              this does make sense, traffic always becomes worse than usual
              during peak period.Peak period appears after adults getting off
              work and children leaving school. That explains the largest amount
              of collisions happened in the afternoon. Moreover,
              driving at night is more difficult because of light
              conditions. Dark environment will affect drivers’ visions.
              So, collisions are more likely to happen.
              "),
      tags$li("Collisions happened a lot when the road is dry.
              We see several places with high density of car accidents.
              Such as Rainier Ave Street, Aurora Ave N, 15th Ave W,
              Lake City Way NE, Martin Luther King Jr Way S.
              These are main roads cross the city and connecting
              to nearby cities. Accidents are easy to happen when
              traffic flows are getting intense. Furthermore, downtown
              Seattle had constructions in many areas which made
              driving in downtown more difficult. High population
              density will also increase the probability of collisions."),
      tags$li("The result for Casualty & Weather part is unexpected
              because we originally think bad weathers will lead to more
              casualties. Turns out, the reality is that most casualties
              happened in clear weather. So, one possible reason could
              be the direct harsh sunlight that could influence drivers’
              vision, which will increase the probability of accidents.
              Another reason could be that clear and partly cloudy days
              take the largest proportion all over the year."),
      tags$li("Collisions happened most in blocks. If the city wants
              to reach the goal of Vision Zero, the government should
              figure out why accidents always happened in the mid of
              blocks and try to find a way to prevent the accidents.
              Luckily, the government has plan for improving the traffic
              conditions. Seattle Department of transportation states
              that: traffic collisions aren't accidents - they're
              preventable through smarter street design, targeted
              enforcement, and thoughtful public engagement. Together,
              we can make Seattle's streets safer for everyone.")
    ),
    p("Source: https://www.seattle.gov/visionzero")
  )
)
