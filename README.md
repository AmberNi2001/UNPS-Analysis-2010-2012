# Project: Uganda National Panel Survey Analysis (2010-2012) 
**Author**: Amber Ni 
| **Date**: 02-11-2025 | **Course**: Adanced Econometrics 

## Project Description
This project analyzes microdata from the **Uganda National Panel Survey** conducted over two waves between 2010 and 2012. The primary focus is on identifying **key determinants of poverty and labor force participation** with descriptive statistics and regression. Conducted in **STATA**, the project involves data cleaning, variable creation, dataset merging, and both descriptive and regression analyses to explore relationships between these variables and their potential correlates. 

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
   2. All raw datasets are stored in `1_Input` ; All codes are stored in `2_Codes` ; All output datasets and the log file are stored in `3_Output`.
   4. Open the `0_master.do` file in STATA.
   5. Modify the global root path in the `0_master.do file` to match the directory structure. This will ensure all scripts and data files are properly linked. For example:
      ```global root "C:/path/to/your/folder"```
   6. Run the `0_master.do file` to execute the entire analysis workflow.

If you're only **interested in viewing the code**: Simply download or browse all the `.do` files directly under folder `2_Codes` in this repository.

- Amber is responsible for analysis regarding porverty (check do files `1d_merge_UGA_wave1_HH.do`, `1e_merge_UGA_wave2_HH.do`, and `1f_merge_UGA_waves_HH.do`) 
* Jessie is responsible for analysis regarding labor force participation (check do files `1a_merge_UGA_wave1_IND.do`, `1b_merge_UGA_wave2_IND.do`, and `1c_merge_UGA_waves_IND.do`) 
+ `0_master.do` and `2_descriptive_statistcs.do` are co-authored by Amber and Jessie.

You can see my final analysis slides for regressions `RegAnalysis_AN.pdf`.

## Data Source 
I downloaded the data from [microdata.worldbank.org](https://microdata.worldbank.org/index.php/home). \
Wave 1 (2010-2010): https://microdata.worldbank.org/index.php/catalog/2166/study-description \
Wave 1 (2011-2012): https://microdata.worldbank.org/index.php/catalog/2059 \

The orginal data folder contains 98 datasets for wave 1 and 103 for wave 2, with the average number of observations exceeding 25,000.

## Workflow
1. **Download Datasets & Organize Locally** 
   - Set up a structured folder system for raw data, scripts, outputs, and documentation.
2. **Review Documentation** 
   - Read the Basic Information Document, Questionnaires, and Survey Reports to understand survey design, variables, and methodology.
3. **Confirm Variables of Interest** 
   - Poverty or Per Capita Consumption: Focus on household-level analysis. 
   - Labor Force Participation: Focus on individuals aged 14+.
4. **Identify Determinants & Correlates** 
   - Select 20-30 potential variables that influence poverty and labor force participation.
5. **Create Variable Spreadsheet** 
   - Track variables, descriptions, coding, and any transformations.
6. **Data Preparation** 
   - Inspect Variables: Check data types, distributions, and completeness. 
   - Clean Variables: Recode where necessary, handle missing data, correct errors, and check identifiers. 
   - Merge Datasets
7. **Descriptive Analysis** 
   - Conduct summary statistics (mean, median, distribution) to get an overview of key variables. 
   - Visualize trends and patterns using charts or tables.
8. **Regression Analysis about Poverty in household level** 
   - Perform summary statisitcs and investigate **pair-wise correlation**. 
   - Use Machine Learning methods for variable selection, including **Stepwise** and **LASSO**. Check **multicollinearity** using **VIF**. 
   - Perform regression models (**Pooled OLS, Fixed Effects, Random Effects**) to explore relationships between variables of interest and their determinants ; Compare results. 
   - Interpret coefficients and statistical significance.


