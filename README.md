# nyc-dog-waste-snowstorm-analysis
Modeling NYC dog waste complaints before and after major snowstorms using Poisson and quasi-Poisson regression.

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

# Dataset

This project uses publicly available NYC Open Data 311 Service Request records and supplementary census data.

Because the raw datasets are extremely large, they are not included directly in this repository.

## NYC Open Data 311 Dataset

Source:

https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2010-to-Present/erm2-nwe9

Users can download:
- CSV files
- Filtered complaint records
- API access

This project specifically filters for dog waste related complaints.

## U.S. Census Data

Source:

https://www.census.gov/data.html

Potential future work may incorporate:
- Population density
- Socioeconomic indicators
- Neighborhood demographic variables

---

# Methodology

Daily complaint counts were aggregated and grouped into three storm periods:

- Pre-Storm (30 days before snowfall)
- During Storm
- Post-Storm (30 days after snowfall)

Poisson regression models were initially estimated because the dependent variable represents count data.

Model specification:

```r
count ~ storm_period
```

Diagnostic testing revealed substantial overdispersion in all models. Because the variance exceeded the mean, quasi-Poisson regression models were estimated to produce corrected standard errors and more reliable statistical inference.

---

# Exploratory Data Analysis

## January 2022 Storm

| Storm Period | Total Complaints |
|---|---|
| During Storm | 2 |
| Post Storm | 243 |
| Pre Storm | 158 |

The January 2022 storm showed a moderate increase in complaints following snowfall. Complaint activity remained low during the storm itself and increased after snow began to melt.

---

## January 2026 Storm

| Storm Period | Total Complaints |
|---|---|
| During Storm | 27 |
| Post Storm | 1156 |
| Pre Storm | 235 |

The January 2026 storm produced the largest post-storm spike in complaints. Complaint totals increased dramatically after snowfall, suggesting delayed reporting or increased visibility after melting periods.

---

## February 2026 Storm

| Storm Period | Total Complaints |
|---|---|
| During Storm | 121 |
| Post Storm | 499 |
| Pre Storm | 1121 |

Unlike previous storms, the February 2026 event produced lower complaint totals after the storm period.

---

# Results

## January 2022 Storm

### Poisson Regression Results

| Variable | Coefficient | p-value | IRR |
|---|---|---|---|
| During Storm | -1.111 | 0.118 | 0.329 |
| Post Storm | 0.321 | 0.00167 | 1.38 |

### Model Fit

| Metric | Value |
|---|---|
| Null Deviance | 143.49 |
| Residual Deviance | 128.08 |
| AIC | 338.94 |

The Poisson model indicated a statistically significant increase in complaints after the storm period. The Incident Rate Ratio of 1.38 suggests that post-storm complaints increased by approximately 38%.

### Quasi-Poisson Results

| Variable | Coefficient | p-value |
|---|---|---|
| During Storm | -1.111 | 0.329 |
| Post Storm | 0.321 | 0.052 |

### Dispersion Diagnostics

| Metric | Value |
|---|---|
| Mean | 7.20 |
| Variance | 20.92 |
| Dispersion Statistic | 2.51 |

The dispersion statistic indicated moderate overdispersion, requiring quasi-Poisson adjustment.

---

## January 2026 Storm

### Quasi-Poisson Results

| Variable | Coefficient | p-value | IRR |
|---|---|---|---|
| During Storm | -0.459 | 0.602 | 0.63 |
| Post Storm | 1.358 | < 0.001 | 3.89 |

### Model Fit

| Metric | Value |
|---|---|
| Null Deviance | 1406.24 |
| Residual Deviance | 835.73 |
| AIC | 1102.89 |

The January 2026 storm produced a 289% increase in post-storm complaints.

---

## February 2026 Storm

### Quasi-Poisson Results

| Variable | Coefficient | p-value | IRR |
|---|---|---|---|
| During Storm | 0.076 | 0.860 | 1.08 |
| Post Storm | -0.809 | 0.0015 | 0.45 |

### Model Fit

| Metric | Value |
|---|---|
| Null Deviance | 1303.89 |
| Residual Deviance | 1042.64 |
| AIC | 1351.58 |

The February 2026 storm produced a 55% decrease in post-storm complaints.

---

# Key Findings

The analysis revealed several important trends:

- Snowstorms significantly affect dog waste complaint patterns.
- Most storms produced increases in complaints after snowfall.
- January 2026 produced the largest increase, with complaints rising by 289%.
- February 2026 produced a 55% decrease in complaints after the storm.
- Complaint behavior varies considerably across storm events.

These findings suggest that snowfall changes environmental visibility, public reporting behavior, and potentially sanitation conditions across the city.

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
