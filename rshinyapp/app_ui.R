library("shiny")
library("ggplot2")
library("dplyr")
library("tidyr")
library("plotly")
library("tidyverse")
library("rsconnect")
library("lintr")
library("leaflet")

# The Intro Page.

source("intro_and_summary.R")

# The Map Page.
map_sidebar_content <- sidebarPanel(
  road_condition_input <- selectInput(
    "road_condition_choice",
    label = "Choice of road condition for the first Map.",
    choices = c(
      "Dry", "Wet",
      "", "Snow/Slush", "Ice", "Sand/Mud/Dirt",
      "Oil", "Standing Water",  "Other", "Unknown"),
    selected = "Dry"
  ),
  color_map_input <- selectInput(
    "map_color",
    label = "Choice of Color.",
    choices = list(
      Red = "Red", Cyan = "#45B39D", Soft_red = "#FF5733", Gray = "#808080"
    ),
    selected = "Red"
  ),
  month_map_input <- selectInput(
    "map_month_choice",
    label = "Choice of month for the second Map",
    choices = list(
      Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6, Jul = 7, Aug = 8,
      Sep = 9, Oct = 10, Nov = 11, Dec = 12
    ),
    selected = 9
  ),
  p(h4("In the map, we are trying to find out
       the accident distribution in Seattle, and we can see
       how road condition is affecting the accident. And what more in depth is,
       we found out that there are several streets have unsually
       high accident propensity. Which are:
       Rainier Ave Street,
       Aurora Ave N,
       15th Ave W,
       Lake City Way NE,
       Martin Luther King Jr Way S. For this finding, we can
       see there are more problems happened in these specific roads. For this
       valuable information, we can suggest the government to do something to
       improve the road or trying to find out ways to figure out why there is
       more accidents happening and then there will be less people get injured
       or just stuck in the middle of the road due to accident."))
  )



map_main_content <- mainPanel(
  div(
    leafletOutput("map"),
    leafletOutput("map2"),
    class = "map-panel"
  )
)

map_panel <- tabPanel(
  "Accident Distribution Map",
  div(
    class = "main",
    h2("Seattle Car Accident Distribution According to Road Condition",
       class = "tab-title"),
    sidebarLayout(
      map_sidebar_content,
      map_main_content
    )
  )
)

# The Bar Chart
bar_numeric_y <- selectInput(
  "bar_y_var",
  label = "Types of Involvement",
  choices = c("Pedestrians", "Cyclists", "People",
              "Injuries", "Fatalities", "Collisions"),
  selected = "People"
)

bar_time_x <- radioButtons(
  "bar_x_var",
  label = "Time Frame",
  choices = list("Weekday" = "Weekday",
                 "Part of Day" = "part_of_day",
                 "Month" = "Month"),
  selected = "Weekday"
)

bar_side_input <- sidebarPanel(
  bar_numeric_y,
  bar_time_x
)

bar_main_content <- mainPanel(
  plotlyOutput("bar")
)

bar_tab <- tabPanel(
  "Involvement & Time",
  div(
    class = "main",
    h2("People Involved During Different Times", class = "tab-title"),
    sidebarLayout(
      bar_side_input,
      bar_main_content),
    p("This bar chart aims to show if there is a the relationship between
      different involvements with different time elements in collisions. This
      chart should answer various time related questions such as what part of
      day, and month do more crashes occur. There are three different time
      options: part of day, weekday, and year. The different involvments are
      total injuries, fatalities, crashes, pedestrians, cycilists, and people
      involved in Seattle 2018 collisions. ")
  )
)

# The circle packing.
weather_chart <- tabPanel(
  "Casualty & Weather", # label for the page
  div(
    class = "main",
    h2("Casualties in Different Weather Conditions", class = "tab-title"),

    sidebarLayout(
      sidebarPanel(
        # selections for casualty type
        radioButtons(
          inputId = "casualty_type",
          label = "Casualty Type",
          choices = c("Injuries",
                      "Serious Injuries",
                      "Total Injuries",
                      "Fatalities",
                      "Total Casualties"
          ),
          selected = "Total Casualties"
        )
      ),

      mainPanel(
        ggiraphOutput(outputId = "weather")
      )
    ),
    p("The circle packing visualization shows the number of
    people with different casualty types in different
    weather conditions in Seattle 2018 collisions. The
    chart tries to reveal the correlation between casualty
    and weather conditions. Besides showing casualties in
    different weather conditions, the chart also helps us
    compare the casualties in different weathers directly.")
  )
)


# The Conclusion Page.

 
# THe navbarPage function to hold all pages.
ui <- navbarPage(
  "Integrated Collision Research In Seattle",
  intro_panel,
  bar_tab,
  map_panel,
  weather_chart,
  summary_plots_panel,
  summary_info_panel
)
