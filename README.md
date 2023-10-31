
<br>

## An Environmental Justice Analysis of Air Pollution Emissions in the United States from 1970 to 2010

This repository houses the code and data used in the analysis presented in the peer-reviewed article: *An Environmental Justice Analysis of Air Pollution Emissions in the United States from 1970 to 2010*.

Below is the description of the repository's content. Please contact the corresponding author, Yanelli Nunez, with any questions regarding the contents of this repository. 

#######################################################################

- 0_00_create_folder_structure.R
Creates folder structure and directories of the repository. No need to run or review

#######################################################################

**Data Folder**

- emissions_data: sub-folder containing the county-level emissions estimates for the seven pollutants analyzed
- census_data: sub-folder containing all census data variables we used as independent variables. The CPI_U_RS.xlsx/CPI_URS_edit.xlsx contain indexes we used to adjust the dollar variables to 2010 dollars. 
- generated_data: sub-folder containing the generated files from the cleaning and compiling of census and emissions data. The descriptions for each dataset within this sub-folder are below.  

*Generated datasets descriptions*:

- data_indp_varib_1: contains race/ethnicity, poverty, employment, income, education, and house value
- data_indp_varib_2: same as version "1" but it also includes property and income variables
- data_indp_varib_3: same as version "2" but it also includes urbanicity and EPA region variables
- data_indp_varib_3_inflat_adjs: same as version "3" but includes property and income variables adjusted for inflation to the year 2010 dollars
- data_indp_varib_4: same as version 3 inflation-adjusted but it includes a county area and population density variable and a variable called "name", which are the county names without the suffixes "county"
- emissions_all_data: contains emission fluxes for all seven chemical pollutants for 1970, 1980, 1990, 2000, 2010, and 2017. Note that I changed the name of Miami-Dade to Miami so that it would be consistent across the study period
- emissions_diff_reltv_chg: contains emission fluxes, absolute difference, and relative change from decennial to decennial. Dade appears as Miami-Dade throughout
- master_data: contains all independent and dependent variables. Dade appears as Miami-Dade throughout 
- master_nox_energy: contains all variables; select the 95th percentile of nox_energy data to remove extreme values
- master_so2_energy: contains all variables; select the 95th percentile of so2_energy data to remove extreme values
- master_so2_industry: contains all variables; removed infinity values resulting from changes from zero to nonzero emissions values and substitute NaN (resulting from changes in emissions from zero to zero [e.g. 0-0/0 -> NaN]) with zero
- income_propt_estim1970: property and income estimates for 1970 using aggregated data from the census


#######################################################################

**Code Folder**
Folder containing all code. Run the .rmds files within each folder in order based on the numeric portion of the name. Further details describing the code are included within each .rmd file.  

data_loading.R: this R script is called from within each of models .rmds 

- data_prep: sub-folder containing the code used to wrangle all variables
- data_explor: sub-folder containing a single .rmd file with code to estimate the correlation among the independent variables
- models: sub-folder containing all models used for the main and sensitivity analyses
- figures: sub-folder housing the code that makes the paper figures
- packages: sub-folder housing a script that loads all packages needed. 

#######################################################################

**Figures Folder**
This folder contains some of the paper figures/tables but not all because some were too large. 

#######################################################################

**Output Folder**
This folder has a single .csv file with the coefficients from the linear models
