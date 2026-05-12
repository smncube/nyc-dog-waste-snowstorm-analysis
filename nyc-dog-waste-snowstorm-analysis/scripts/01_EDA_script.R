# Loading my libraries

library(dplyr)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(scales)

# loading my data and preparing it 

data <- read.csv(
  "data/raw/311_service_requests_dog_waste_filtered.csv",
  stringsAsFactors = FALSE,
  na.strings = c("", "NA", "N/A")
)

# converting the date

data <- data %>%
  mutate(
    Created.Date = as.character(Created.Date),
    date = mdy_hms(Created.Date),
    date = as.Date(date),
    year = year(date)
  )

# Function for EDA

run_storm_eda <- function(storm_name, storm_start, storm_end) {
  
  # defining storm window
  
  storm_start <- as.Date(storm_start)
  storm_end   <- as.Date(storm_end)
  
  pre_start  <- storm_start - 30
  pre_end    <- storm_start - 1
  
  post_start <- storm_end + 1
  post_end   <- storm_end + 30
  
  # Creating storm period variable
  
  storm_data <- data %>%
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
  
  daily_counts <- storm_data %>%
    group_by(date, storm_period) %>%
    summarise(count = n(), .groups = "drop")
  
  # Plotting the daily complaints 
  
  line_plot <- ggplot(
    daily_counts,
    aes(x = date, y = count, color = storm_period)
  ) +
    geom_line(size = 1) +
    geom_point(size = 2) +
    labs(
      title = paste(
        "Dog Droppings Complaints Before, During, and After",
        storm_name
      ),
      x = "Date",
      y = "Number of Complaints"
    ) +
    scale_x_date(
      date_labels = "%b %d",
      date_breaks = "5 days"
    ) +
    theme_minimal()
  
  print(line_plot)
  
  # Saving the line plot
  
  ggsave(
    paste0(
      "outputs/figures/",
      gsub(" ", "_", tolower(storm_name)),
      "_line_plot.png"
    ),
    plot = line_plot,
    width = 10,
    height = 6
  )
  
  # Summary table of total complaints per storm period
  
  summary_table <- storm_data %>%
    group_by(storm_period) %>%
    summarise(total_complaints = n(), .groups = "drop")
  
  print(summary_table)
  
  # Saving the summary table
  
  write.csv(
    summary_table,
    paste0(
      "outputs/tables/",
      gsub(" ", "_", tolower(storm_name)),
      "_summary_table.csv"
    ),
    row.names = FALSE
  )
  
  # Bar chart of total complaints per period
  
  bar_plot <- ggplot(
    summary_table,
    aes(
      x = storm_period,
      y = total_complaints,
      fill = storm_period
    )
  ) +
    geom_col() +
    geom_text(
      aes(label = total_complaints),
      vjust = -0.5
    ) +
    labs(
      title = paste(
        "Total Dog Droppings Complaints per Storm Period",
        paste0("(", storm_name, ")")
      ),
      x = "Storm Period",
      y = "Total Complaints"
    ) +
    theme_minimal() +
    theme(legend.position = "none")
  
  print(bar_plot)
  
  # Saving the bar chart
  
  ggsave(
    paste0(
      "outputs/figures/",
      gsub(" ", "_", tolower(storm_name)),
      "_bar_chart.png"
    ),
    plot = bar_plot,
    width = 8,
    height = 5
  )
  
}

# January 2022 Storm

run_storm_eda(
  storm_name = "January 2022 Storm",
  storm_start = "2022-01-28",
  storm_end = "2022-01-29"
)

# January 2026 Storm

run_storm_eda(
  storm_name = "January 2026 Storm",
  storm_start = "2026-01-24",
  storm_end = "2026-01-27"
)

# February 2026 Storm

run_storm_eda(
  storm_name = "February 2026 Storm",
  storm_start = "2026-02-21",
  storm_end = "2026-02-23"
)