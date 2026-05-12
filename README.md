# Snowstorms, Visibility, and Public Complaints in New York City

## Modeling Dog Waste Complaints Following Major Snow Events

### Author
Sethu Mncube

---

# Project Overview

This project investigates how major snowstorms affect dog waste complaints submitted through the NYC 311 system. Using exploratory data analysis and generalized linear models for count data, the project evaluates whether complaint behavior changes before, during, and after major winter snowstorms in New York City.

The analysis focuses on three storm periods:

- January 2022
- January 2026
- February 2026

The project combines:
- Exploratory Data Analysis (EDA)
- Poisson Regression
- Quasi-Poisson Regression
- Incident Rate Ratios (IRRs)
- Overdispersion Diagnostics
- Model Fit Evaluation

The findings demonstrate that snowstorms significantly alter complaint patterns, though the direction and magnitude of the effect vary substantially across storm events.

---

# Research Question

Does snowfall significantly increase the number of dog droppings complaints in NYC in the 30 days following a major snowstorm?

---

# Hypothesis

Snowstorms significantly change the number of daily dog waste complaints reported through NYC 311.

---

# Null Hypothesis

There is no significant difference in the mean number of daily dog waste complaints before, during, and after major snowstorms.

---

# Data Sources

## NYC Open Data 311 Service Requests

Source:

https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2010-to-Present/erm2-nwe9

The dataset contains:
- Complaint type
- Complaint descriptor
- Complaint dates
- Agency information
- Borough information
- Geographic information

This project filters specifically for dog waste related complaints.

---

# Replicating the Data Query

The NYC Open Data portal was filtered to isolate dog waste complaints.

The query structure used:

- Complaint Type related to sanitation and dirty conditions
- Descriptor containing dog waste related complaints
- Date ranges including:
  - January 2022
  - January 2026
  - February 2026

To replicate the dataset:

1. Open the NYC Open Data portal
2. Click “Filter”
3. Filter complaint descriptors for dog waste related records
4. Export the filtered results as CSV
5. Save the file as:

```text
311_service_requests_dog_waste_filtered.csv
```

6. Place the file into:

```text
data/raw/
```

---

# Scripts

## 01_EDA_script.R

This script performs exploratory data analysis for all three snowstorms.

The script:
- Loads and cleans the dataset
- Converts dates into usable time variables
- Creates pre-storm, during-storm, and post-storm periods
- Aggregates daily complaint counts
- Produces line plots
- Produces bar charts
- Saves figures and summary tables into the outputs folder

Outputs generated:
- Line plots
- Bar charts
- Summary tables

Saved into:

```text
outputs/figures/
outputs/tables/
```

---

## 02_storm_models.R

This script performs all statistical modeling for the project.

The script:
- Filters data for each storm event
- Aggregates daily complaint counts
- Fits Poisson regression models
- Calculates incident rate ratios
- Tests for overdispersion
- Fits quasi-Poisson models
- Calculates model fit statistics
- Performs analysis of deviance tests
- Produces boxplots of complaint distributions
- Saves statistical outputs into the outputs folder

Outputs generated:
- Poisson model summaries
- Quasi-Poisson summaries
- IRR tables
- ANOVA tables
- Boxplots

Saved into:

```text
outputs/figures/
outputs/tables/
```

---

# Running the Project

## Step 1 — Download the Data

Download the filtered NYC 311 dataset and save it as:

```text
311_service_requests_dog_waste_filtered.csv
```

Place the file into:

```text
data/raw/
```

---

## Step 2 — Open the Project in RStudio

Open the project folder as an R Project.

All scripts use relative paths and can run directly from the project root directory.

---

## Step 3 — Run the Scripts

Run the scripts in the following order:

### 1. Exploratory Data Analysis

```text
scripts/01_EDA_script.R
```

### 2. Statistical Models

```text
scripts/02_storm_models.R
```

---

# Statistical Models

The primary model estimated:

```r
count ~ storm_period
```

Where:
- `count` represents daily dog waste complaints
- `storm_period` represents:
  - Pre Storm
  - During Storm
  - Post Storm

Poisson regression was initially used because the dependent variable represents count data.

Overdispersion diagnostics revealed that the variance substantially exceeded the mean in several models. Because this violates standard Poisson assumptions, quasi-Poisson models were also estimated.

---

# Key Findings

## January 2022 Storm

EDA results:
- Pre Storm complaints: 158
- During Storm complaints: 2
- Post Storm complaints: 243

Poisson regression results:
- Post-storm complaints were 1.38 times higher than pre-storm complaints
- The post-storm effect was statistically significant
- During-storm complaints decreased substantially

Overdispersion diagnostics:
- Mean: 7.20
- Variance: 20.92
- Dispersion statistic: 2.51

Quasi-Poisson results weakened statistical significance slightly but retained the same directional pattern.

---

## January 2026 Storm

EDA results:
- Pre Storm complaints: 235
- During Storm complaints: 27
- Post Storm complaints: 1156

Poisson regression results:
- Post-storm complaints were 3.89 times higher than pre-storm complaints
- The post-storm effect was highly statistically significant
- During-storm complaints decreased during active snowfall

Overdispersion diagnostics:
- Mean: 26.93
- Variance: 959.89
- Dispersion statistic: 18.58

The January 2026 storm produced the strongest increase in complaints across all storm periods analyzed.

---

## February 2026 Storm

EDA results:
- Pre Storm complaints: 1121
- During Storm complaints: 121
- Post Storm complaints: 499

Poisson regression results:
- Post-storm complaints were only 0.45 times the pre-storm level
- Complaint counts significantly decreased after the storm

Overdispersion diagnostics:
- Mean: 27.63
- Variance: 826.88
- Dispersion statistic: 20.42

Unlike the other storms, February 2026 produced a substantial decline in post-storm complaints.

---

# Interpretation

The results suggest that snowstorms significantly alter public complaint behavior related to dog waste visibility and sanitation conditions.

Across all storms:
- Complaints declined sharply during active snowfall
- Complaint patterns shifted substantially after snow accumulation and melting

However, the magnitude and direction of post-storm changes varied considerably.

The January 2026 storm produced the strongest post-storm increase in complaints, suggesting that snow concealment followed by snowmelt may have exposed accumulated waste conditions.

By contrast, the February 2026 storm produced a significant decline in post-storm complaints, indicating that storm conditions and municipal response may vary substantially across events.

The strong overdispersion observed in all models indicates substantial unexplained variability in daily complaint behavior. For this reason, quasi-Poisson models provided more appropriate standard errors and inference.

---

# Limitations

Several limitations should be acknowledged:

- The analysis measures complaint counts rather than sanitation response times
- Weather severity variables were not directly modeled
- Borough-level differences were not included
- Temporal autocorrelation may exist
- 311 complaints reflect reporting behavior rather than direct environmental measurement

Future work could incorporate:
- Spatial analysis
- Borough-level modeling
- Census data
- Weather severity measures
- Municipal response time analysis

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
