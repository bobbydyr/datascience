# chart of collision type compared to peds and cyclists

# filter for the three rows needed:
ped_cycle_plot <- function(df) {
  only_ped_df <- df %>%
  filter(COLLISIONTYPE == "Pedestrian") %>%
  select(PEDCOUNT, PEDCYLCOUNT, INCDTTM) %>%
  mutate(time = sub("^\\S+\\s+", "", INCDTTM)) %>% # just time, no date
  # turns all time to military time
  mutate(time_only = format(strptime(time, "%I:%M:%S %p"), "%H")) %>%
  # morning 5am - 12pm, afternoon 12-5pm, evening 5-9pm, night 9pm - 4am
  mutate(part_of_day =
          ifelse(time_only %in% 5:12, "Morning",
          ifelse(time_only %in% 12:17, "Afternoon",
          ifelse(time_only %in% 17:21, "Evenining", "Night")))) %>%
  select(PEDCOUNT, PEDCYLCOUNT, part_of_day) %>%
  group_by(part_of_day) %>%
  summarise(n_ped = sum(PEDCOUNT),
            n_cycle = sum(PEDCYLCOUNT))

  # maintain order or time
  level_order <- c("Morning", "Afternoon", "Evenining", "Night")

   map <- ggplot(only_ped_df, aes(x = only_ped_df$part_of_day, y = value),
                 level = level_order) +
                geom_col(aes(y = only_ped_df$n_ped, col = "Pedestrian")) +
                geom_col(aes(y = only_ped_df$n_cycle, col = "Cyclists")) +
          labs(title = "Pedestrian and Cyclists Involved In Accidents During
               Time of Day",
               x = "Time of Day",
               y = "Number of People Involved")

   map
}