# summary info for the intro paragraph

seattle_traf_df <- read.csv("data/df_2018.csv",
                       stringsAsFactors = FALSE)


get_info_summary <- function(df) {
  df <- df %>%
    mutate(day = wday(as.Date(INCDTTM), label = T))

  summary_list <- list()

  summary_list$number_crashes <- nrow(df)

  summary_list$total_fatalities <- df %>% # total fatalities
    summarise(n_fatal = sum(FATALITIES)) %>%
    pull(n_fatal)

  summary_list$most_junction <- df %>% # type of junction with most crashes
    group_by(JUNCTIONTYPE) %>%
    summarise(n_all = n()) %>%
    filter(n_all == max(n_all)) %>%
    pull(JUNCTIONTYPE)

  summary_list$ped_injuries <- df %>% # total pedestrain injuries
    summarise(n_ped = sum(PEDCOUNT)) %>%
    pull(n_ped)

  summary_list$most_day_of_week <- df %>% # weekday with most incidents
    filter(!is.na(day)) %>%
    group_by(day) %>%
    summarise(n_day = n()) %>%
    filter(n_day == max(n_day)) %>%
    pull(day) %>%
    as.character()

  summary_list
}

test <- get_info_summary(seattle_traf_df)