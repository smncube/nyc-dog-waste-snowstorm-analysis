# FEBRUARY STORM 2026 MODEL
# Loading my libraries 

library(dplyr)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(broom)

# loading my data and preparing it 
data <- read.csv(
  "~/Downloads/311_service_requests_dog_waste_filtered.csv",
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


# filtering the year

data <- data %>%
  filter(year == 2026)

#  defining storm window
storm_start <- as.Date("2026-02-21")
storm_end   <- as.Date("2026-02-23")

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

# Ensure factor order
daily_counts$storm_period <- factor(
  daily_counts$storm_period,
  levels = c("Pre Storm", "During Storm", "Post Storm")
)

# fitting the poission model
poisson_model <- glm(
  count ~ storm_period,
  data = daily_counts,
  family = "poisson"
)

summary(poisson_model)

# Incident rate ratios 
irr_results <- tidy(
  poisson_model,
  exponentiate = TRUE,
  conf.int = TRUE
)

print(irr_results)


# Check Overdipersion
mean_count <- mean(daily_counts$count)
var_count  <- var(daily_counts$count)

cat("Mean:", mean_count, "\n")
cat("Variance:", var_count, "\n")

# Overdispersion test
dispersion <- sum(residuals(poisson_model, type = "pearson")^2) / poisson_model$df.residual
cat("Dispersion statistic:", dispersion, "\n")


# overdispersion exists so im doing quasi poisson
quasi_model <- glm(
  count ~ storm_period,
  data = daily_counts,
  family = "quasipoisson"
)

summary(quasi_model)


# Model fit statistics
cat("Null Deviance:", poisson_model$null.deviance, "\n")
cat("Residual Deviance:", poisson_model$deviance, "\n")
cat("AIC:", AIC(poisson_model), "\n")

# Analysis of deviance
anova_results <- anova(poisson_model, test = "Chisq")
print(anova_results)


# Visualize model results 
ggplot(daily_counts, aes(x = storm_period, y = count)) +
  geom_boxplot() +
  labs(
    title = "Distribution of Complaints by February 2026 Storm Period",
    x = "Storm Period",
    y = "Daily Complaints"
  ) +
  theme_minimal()