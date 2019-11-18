# summary table

make_table <- function(df) {
  df <- df %>% # calculate summary information
    group_by(COLLISIONTYPE) %>%
    summarise(
      number_of_cases = n(),
      number_of_persons = sum(PERSONCOUNT),
      number_of_injuries = sum(INJURIES),
      number_of_serious_injuries = sum(SERIOUSINJURIES),
      fatalities = sum(FATALITIES)
    ) %>%
    dplyr::rename(collision_type = COLLISIONTYPE) %>%
    arrange(-number_of_cases)
  df$collision_type <- replace(df$collision_type,
                               df$collision_type == "", "Unknown")
  # rename the column names
  table <- kable(df, col.names = c("Collision Type", "Number of Incidents",
                               "Number of People", "Number of Injuries",
                               "Number of Serious Injuries", "Fatalities"))
  table
}