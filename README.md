# Snowstorms, Visibility, and Public Complaints in New York City

## Modeling Dog Waste Complaints Following Major Snow Events

### Author
Sethu Mncube

---

# Project Overview

This project investigates how major snowstorms affect dog waste complaints submitted through the NYC 311 system. Using generalized linear models for count data, the analysis evaluates whether complaint behavior changes before, during, and after major winter storms.

The project combines exploratory data analysis with Poisson and quasi-Poisson regression modeling to examine how snowfall influences patterns of public complaints across New York City.

Three major snowstorm periods were analyzed:

- January 2022
- January 2026
- February 2026

The findings demonstrate that snowstorms significantly alter complaint behavior, though the direction and magnitude of the effect vary substantially across events.

The complete analysis, findings, and statistical interpretation are available in:

```text
paper/snowstorm_analysis.md
```

---

# Research Question

Does snowfall significantly increase the number of dog droppings complaints in NYC in the 30 days following a major snowstorm?

---

# Hypothesis

New York City’s response to dog waste complaints improved during the February 2026 snowstorm.

---

# Null Hypothesis

There is no significant difference in the mean number of daily dog waste complaints before and after a major snowstorm.

---

# Data Sources

## NYC Open Data 311 Service Requests

Source:

https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2010-to-Present/erm2-nwe9

The dataset contains:
- Complaint type
- Complaint descriptors
- Complaint dates
- Borough information
- Agency information
- Geographic variables

This project filters specifically for dog waste related complaints.

---

# Replicating the Data Query

The original NYC Open Data dataset was filtered to isolate dog waste complaints.

The query structure used:

- Complaint Type = “Dirty Conditions”
- Descriptor contains dog waste related terms
- Years filtered:
  - 2022
  - 2026

Users can reproduce the dataset by:

1. Opening the NYC Open Data portal
2. Clicking “Filter”
3. Selecting:
   - Complaint Type
   - Descriptor
   - Created Date
4. Exporting the filtered results as CSV

---

# Reproducing the Analysis

## Step 1 — Download the Data

Download the filtered NYC 311 dataset and place it into:

```text
data/raw/
```

The file should be named:

```text
311_service_requests_dog_waste_filtered.csv
```

---

## Step 2 — Open the R Project

Open the project folder in RStudio.

All scripts use relative paths and should run directly from the project root directory.

---

## Step 3 — Run the Scripts in Order

### 1. Exploratory Data Analysis

Run:

```text
scripts/01_EDA_script.R
```

This script:
- Loads and cleans the data
- Converts dates
- Creates storm windows
- Generates summary statistics
- Produces exploratory visualizations

---

### 2. January 2022 Model

Run:

```text
scripts/02_January_2022_model.R
```

This script:
- Filters January 2022 storm data
- Aggregates daily complaint counts
- Runs Poisson regression
- Tests for overdispersion
- Fits quasi-Poisson models
- Generates visualizations

---

### 3. January 2026 Model

Run:

```text
scripts/03_January_2026_model.R
```

This script:
- Filters January 2026 storm data
- Aggregates daily complaint counts
- Runs Poisson regression
- Tests for overdispersion
- Fits quasi-Poisson models
- Generates visualizations

---

### 4. February 2026 Model

Run:

```text
scripts/04_February_2026_model.R
```

This script:
- Filters February 2026 storm data
- Aggregates daily complaint counts
- Runs Poisson regression
- Tests for overdispersion
- Fits quasi-Poisson models
- Generates visualizations

---

# Model Specification

The primary model estimated:

```r
count ~ storm_period
```

Where:
- `count` represents daily dog waste complaints
- `storm_period` represents:
  - Pre-Storm
  - During Storm
  - Post-Storm

Poisson regression was initially used because the outcome variable represents count data.

Diagnostic testing revealed substantial overdispersion, requiring quasi-Poisson adjustment.

---

# Key Findings

The analysis revealed several important trends:

- Snowstorms significantly affect dog waste complaint patterns.
- Most storms produced increases in complaints after snowfall.
- January 2026 produced the largest increase in complaints.
- February 2026 produced a significant decrease in complaints after snowfall.
- Complaint behavior varies substantially across storm events.

These findings suggest that snowfall changes environmental visibility, reporting behavior, and sanitation conditions across the city.

---

# Limitations

Several limitations should be acknowledged:

- The analysis measures complaint volume rather than response time.
- Weather severity variables were not included.
- The model does not include borough-level controls.
- Daily observations may exhibit temporal autocorrelation.
- Overdispersion indicates unexplained variability in the data.

Future work could incorporate:
- Spatial analysis
- Weather severity metrics
- Response-time analysis
- Borough comparisons

---

# Technologies Used

- R
- tidyverse
- dplyr
- ggplot2
- lubridate
- broom

---

# Chicago Style Bibliography

Call, D. 2020. “Snow Events and Cascading Urban Disruption.”

Hsu, Y., C. Lee, and T. Wang. 2019. “Citizen Reporting Behavior and Public Service Systems.”

Minkoff, Susan L. 2016. “NYC 311 and Citizen-Government Interaction.”

Ramphal, R., et al. 2022. “Spatial Disparities in Municipal Complaint Systems.”

Savas, E. S. 1973. “Municipal Snow Management in New York City.”
