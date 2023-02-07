# Data Challenge - for Symmetron

This is a Github repository for conducting the analysis of the exclusion criteria - in terms of age, sex, and selected pre-existing conditions - of cancer-related phase 3 trials in the [ClinicalTrials.gov Database](https://clinicaltrials.gov/).

## Data Extraction
* Register for an account with [AACT](https://aact.ctti-clinicaltrials.org/) to obtain access to the database.
* Use the query in `query_for_data.sql` to extract data through either [pgAdmin](https://aact.ctti-clinicaltrials.org/pgadmin) or [R](https://aact.ctti-clinicaltrials.org/r) into CSV format, following the instructions indicated on the AACT website.
* `raw_AACT_data.csv` contains a copy of the raw data that was obtained on January 23, 2023 that was used for the initial analysis and report.

## Data Analysis
* `Data Cleaning and Analysis.ipynb` contains all the Python code used to read-in the corresponding CSV file and perform the analysis end-to-end. It contains the following sections:
  * Data Read-In: read in the data and import the necessary libraries
  * Data Cleaning: prepare the data for analysis and subset to the relevant studies (currently, it is only limited to cancer-related studies)
  * Initial Analysis: provide the descriptive statistics for number of studies, exclusions by age and sex, and the keyword search
 * Time Trends: 
