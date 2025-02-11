# Project: UGA National Panel Survey Analysis (2010-2012) 
**Author**: Amber Ni
| **Date**: 02-11-2025 | **Course**: Adanced Econometrics 

## Project Description
This project analyzes microdata from the **UGA National Panel Survey** conducted over two waves between 2010 and 2012. The primary focus is on identifying **key determinants of poverty and labor force participation** with descriptive statistics and regression. Conducted in **STATA**, the project involves data cleaning, variable creation, dataset merging, and both descriptive and regression analyses to explore relationships between these variables and their potential correlates. 

The repository **includes**: 
1. raw survey data
2. STATA do files
3. output datasets
4. a STATA log file
5. a variable spreadsheet

This work aims to support researchers, policymakers, and stakeholders interested in poverty dynamics and labor market participation trends.

## How to Use This Repository
If you'd like to **run the analysis** on your own laptop, follow these steps:
   1. Download the ZIP file.
   2. Open the `0_master.do` file in STATA.
   3. Modify the global root path in the `0_master.do file` to match the directory structure. This will ensure all scripts and data files are properly linked. For example:
      ```global root "C:/path/to/your/folder"```
   4. Run the `0_master.do file` to execute the entire analysis workflow.

If you're only **interested in viewing the code**: Simply download or browse the `.do` files directly in this repositor

## Data Source 
I downloaded the data from [microdata.worldbank.org](https://microdata.worldbank.org/index.php/home). \
Wave 1 (2010-2010): https://microdata.worldbank.org/index.php/catalog/2166/study-description \
Wave 1 (2011-2012): https://microdata.worldbank.org/index.php/catalog/2059 \

The orginal data folder contains 98 datasets for wave 1 and 103 for wave 2, with the average number of observations exceeding 25,000.

## Workflow
1. **Download Datasets & Organize Locally** \
   Set up a structured folder system for raw data, scripts, outputs, and documentation.
2. **Review Documentation** \
    Read the Basic Information Document, Questionnaires, and Survey Reports to understand survey design, variables, and methodology.
3. **Confirm Variables of Interest** \
    Poverty or Per Capita Consumption: Focus on household-level analysis. \
    Labor Force Participation: Focus on individuals aged 14+.
4. **Identify Determinants & Correlates** \
    Select 20-30 potential variables that influence poverty and labor force participation.
5. **Create Variable Spreadsheet** \
    Track variables, descriptions, coding, and any transformations.
6. **Data Preparation** \
    Inspect Variables: Check data types, distributions, and completeness. \
    Clean Variables: Recode where necessary, handle missing data, correct errors, and check identifiers. \
    Merge Datasets
7. **Descriptive Analysis** \
    Conduct summary statistics (mean, median, distribution) to get an overview of key variables. \
    Visualize trends and patterns using charts or tables.
8. **Regression Analysis** \
    Perform regression models to explore relationships between variables of interest and their determinants. \
    Interpret coefficients and statistical significance.


