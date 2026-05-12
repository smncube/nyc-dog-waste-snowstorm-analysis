# STORM MODELS
# Loading my libraries 

library(dplyr)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(broom)

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

# Function for storm models

run_storm_model <- function(
    storm_name,
    filter_year,
    storm_start,
    storm_end
) {
  
  # filtering the year
  
  storm_data <- data %>%
    filter(year == filter_year)
  
  # defining storm window
  
  storm_start <- as.Date(storm_start)
  storm_end   <- as.Date(storm_end)
  
  pre_start  <- storm_start - 30
  pre_end    <- storm_start - 1
  
  post_start <- storm_end + 1
  post_end   <- storm_end + 30
  
  # Creating storm period variable
  
  storm_data <- storm_data %>%
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
  
  # Ensure factor order
  
  daily_counts$storm_period <- factor(
    daily_counts$storm_period,
    levels = c("Pre Storm", "During Storm", "Post Storm")
  )
  
  # fitting the poisson model
  
  poisson_model <- glm(
    count ~ storm_period,
    data = daily_counts,
    family = "poisson"
  )
  
  summary(poisson_model)
  
  # Saving poisson model summary
  
  capture.output(
    summary(poisson_model),
    file = paste0(
      "outputs/tables/",
      gsub(" ", "_", tolower(storm_name)),
      "_poisson_summary.txt"
    )
  )
  
  # Incident rate ratios 
  
  irr_results <- tidy(
    poisson_model,
    exponentiate = TRUE,
    conf.int = TRUE
  )
  
  print(irr_results)
  
  # Saving IRR results
  
  write.csv(
    irr_results,
    paste0(
      "outputs/tables/",
      gsub(" ", "_", tolower(storm_name)),
      "_irr_results.csv"
    ),
    row.names = FALSE
  )
  
  # Check Overdispersion
  
  mean_count <- mean(daily_counts$count)
  var_count  <- var(daily_counts$count)
  
  cat("Mean:", mean_count, "\n")
  cat("Variance:", var_count, "\n")
  
  # Overdispersion test
  
  dispersion <- sum(
    residuals(poisson_model, type = "pearson")^2
  ) / poisson_model$df.residual
  
  cat("Dispersion statistic:", dispersion, "\n")
  
  # overdispersion exists so im doing quasi poisson
  
  quasi_model <- glm(
    count ~ storm_period,
    data = daily_counts,
    family = "quasipoisson"
  )
  
  summary(quasi_model)
  
  # Saving quasi poisson summary
  
  capture.output(
    summary(quasi_model),
    file = paste0(
      "outputs/tables/",
      gsub(" ", "_", tolower(storm_name)),
      "_quasi_poisson_summary.txt"
    )
  )
  
  # Model fit statistics
  
  cat("Null Deviance:", poisson_model$null.deviance, "\n")
  cat("Residual Deviance:", poisson_model$deviance, "\n")
  cat("AIC:", AIC(poisson_model), "\n")
  
  # Analysis of deviance
  
  anova_results <- anova(poisson_model, test = "Chisq")
  
  print(anova_results)
  
  # Saving analysis of deviance results
  
  capture.output(
    anova_results,
    file = paste0(
      "outputs/tables/",
      gsub(" ", "_", tolower(storm_name)),
      "_anova_results.txt"
    )
  )
  
  # Visualize model results 
  
  boxplot_model <- ggplot(
    daily_counts,
    aes(x = storm_period, y = count)
  ) +
    geom_boxplot() +
    labs(
      title = paste(
        "Distribution of Complaints by",
        storm_name
      ),
      x = "Storm Period",
      y = "Daily Complaints"
    ) +
    theme_minimal()
  
  print(boxplot_model)
  
  # Saving boxplot
  
  ggsave(
    paste0(
      "outputs/figures/",
      gsub(" ", "_", tolower(storm_name)),
      "_boxplot.png"
    ),
    plot = boxplot_model,
    width = 8,
    height = 5
  )
  
}

# JANUARY 2022 STORM MODEL

run_storm_model(
  storm_name = "January 2022 Storm",
  filter_year = 2022,
  storm_start = "2022-01-28",
  storm_end = "2022-01-29"
)

# JANUARY 2026 STORM MODEL

run_storm_model(
  storm_name = "January 2026 Storm",
  filter_year = 2026,
  storm_start = "2026-01-24",
  storm_end = "2026-01-27"
)

# FEBRUARY 2026 STORM MODEL

run_storm_model(
  storm_name = "February 2026 Storm",
  filter_year = 2026,
  storm_start = "2026-02-21",
  storm_end = "2026-02-23"
)