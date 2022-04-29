## USA_emissions
Temporal analysis of air pollution emission across the United States

## 0_00_create_folder_structure.R
Creates folder structure and directories of the repository. No need to run or review

## Data folder
- emissions_data : folder containing the county-level emissions estimates for the 7 pollutants analyzed
- census_data: folder containing all census data variables that we use as independent variables. The CPI_U_RS.xlsx/CPI_URS_edit.xlsx contain indexes that I used to adjust the dollar variables to 2010 dollars. 
- generated_data: contains the generated files from the cleaning and compiling of census and emissions data. The descriptions for each dataset are below.  

*Generated datasets descriptions*:

- data_indp_varib_1: contains race/ethnicity, poverty, employment, income, education and house value
- data_indp_varib_2: same as version "1" but it also includes property and income variables
- data_indp_varib_3: same as version "2" but it also includes urbanicity and epa regions variables
- data_indp_varib_3_inflat_adjs: same as version "3" but includes property and income variables adjusted for inflation to year 2010 dollars
- data_indp_varib_4: same as version 3 inflation adjusted but it includes a county area and population density variable and a variable called "name", which are the county names without the suffixes "county"
- emissions_all_data: contains emission fluxes for all 7 chemical pollutants for years, 1970, 1980, 1990, 2000, 2010, and 2017. Note that I changed the name of Miami-Dade to Miami so that it would be consistent across the study period
- emissions_diff_reltv_chg: contains emission fluxes, absolute difference and relative change from decennial to decennial. Dade appears as Miami-Dade throughout
- master_data: contains all independent and dependent variables. Dade appears as Miami-Dade throughout 
- master_nox_energy: contains all variables; select the 95th percentile of nox_energy data to remove extreme values
- master_so2_energy: contains all variables; select the 95th percentile of so2_energy data to remove extreme values
- master_so2_industry: contains all variables; removed infinity values resulting from changes from zero to nonzero emissions values and substitute NaN (resulting from changes in emissions from zero to zero [e.g. 0-0/0 -> NaN]) with zero
- income_propt_estim1970: property and income estimates for 1970 using aggregated data from the census

######################## ignore for now ############################
*Other datasets generated*:
This datasets are located in my local drive because they are way too large to push to GitHub
- geometries_counties: spatial county geometries for 1970-2010 compile in population_density.Rmd

- us_counties_over_time: includes code for preparing the county over time dataset, including the county geometries
- emis_pollutant_sector_centroids.rds: contains emission fluxes for each centroid of the CEDS grid and each year of the study period (pollutant and sector in the file name refer to specific pollutant and sector names)
- emis_pollutant_sector_county_df.rds: contains emission fluxes for each county and each year of the study period (pollutant and sector in the file name refer to specific pollutant and sector names)

#######################################################################

## Code:
Folder containing all code. 
Run .rmds within each folder in order based on the numeric portion of the name
data_loading.R --> this R script is called from within the models .rmds so that I do not have to be loading the data within each .rmd

- data_prep: includes code used to wrangle all variables
- data_explor: contains a single .rmd where i estimated the correlation among the independent variables
- models: contains all models for the analysis
- figures: code for making the paper figures
- packages: a script that loads all packages needed. You do not need to run this independently. 


## figures:
I saved some of the paper figures/tables here but not all of them because some of them were a bit too large. 

## output:
.csv that contains the coefficients from the linear models
.xlsx file if for Figure 4 of paper
