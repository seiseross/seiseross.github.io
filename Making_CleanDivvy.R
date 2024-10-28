#Load tidyverse packages
library(tidyverse)

#Reading the data files in my working directory to create a data frame.
DivvyDataNames = list.files(pattern="\\.csv$")
DivvyDataframes = lapply(DivvyDataNames, read_csv)
df <- as_tibble(data.table::rbindlist(DivvyDataframes))

#filter out NA values
df_filtered <- df %>% 
  filter(!is.na(end_station_name)) %>% 
  filter(!is.na(start_station_name))

#Adding a trip length and month column
df_proc <- df_filtered %>% 
  mutate(trip_length = round(as.numeric((ended_at - started_at)/60),2),
         year_month = format(as.Date(ended_at, format= "%Y-%m-%d %h:%m:%s"),
                             "%Y-%m"),
         year_month2 =lubridate::as_date(year_month, format= "%Y-%m"),
         weekday = wday(ended_at, label = TRUE),
         rider_type = str_to_title(member_casual),
         bike_type = case_when(rideable_type == "classic_bike" ~ "Classic",
                               rideable_type == "electric_bike" ~ "Electric")
  )
saveRDS(df_proc, "CleanDivvy.RDS")