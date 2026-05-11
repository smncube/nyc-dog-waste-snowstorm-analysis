# Loading my libraries
library(dplyr)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(scales)


# Getting the data
data <- read.csv(
  "~/Documents/Data Analysis Project/311_Service_Requests_from_2020_to_Present_20260223.csv",
  stringsAsFactors = FALSE,
  na.strings = c("", "NA", "N/A"))

# Converting 'Created.Date' to the Date
data <- data %>%
  mutate(
    Created.Date = as.character(Created.Date),
    date = mdy_hms(Created.Date),    
    date = as.Date(date),            
    year = year(date))

# Filtering for 2022 only
data <- data %>%
  filter(year == 2022)


#  defining storm window
storm_start <- as.Date("2022-01-28")
storm_end   <- as.Date("2022-01-29")

pre_start  <- storm_start - 30
pre_end    <- storm_start - 1
post_start <- storm_end + 1
post_end   <- storm_end + 30

# Creating storm period variable
data <- data %>%
  mutate(
    storm_period = case_when(
      date >= pre_start & date <= pre_end     ~ "Pre Storm",
      date >= storm_start & date <= storm_end ~ "During Storm",
      date >= post_start & date <= post_end   ~ "Post Storm",
      TRUE ~ NA_character_
    )
  ) %>%
  filter(!is.na(storm_period))

# Aggregating my daily counts 
daily_counts <- data %>%
  group_by(date, storm_period) %>%
  summarise(count = n(), .groups = "drop")

# Plotting the daily complaints 
ggplot(daily_counts, aes(x = date, y = count, color = storm_period)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(
    title = "Dog Droppings Complaints Before, During, and After January 2022 Snow Storm",
    x = "Date",
    y = "Number of Complaints"
  ) +
  scale_x_date(date_labels = "%b %d", date_breaks = "5 days") +
  theme_minimal()

# Summary table of total complaints per storm period
summary_table <- data %>%
  group_by(storm_period) %>%
  summarise(total_complaints = n(), .groups = "drop")

print(summary_table)

# Bar chart of total complaints per period
ggplot(summary_table, aes(x = storm_period, y = total_complaints, fill = storm_period)) +
  geom_col() +
  geom_text(aes(label = total_complaints), vjust = -0.5) +
  labs(
    title = "Total Dog Droppings Complaints per Storm Period (January 2022)",
    x = "Storm Period",
    y = "Total Complaints"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

