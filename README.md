# USA_emissions
Temporal analysis of air pollution emission across the United States


*Generated datasets descriptions*:

- data_indp_varib_1: contains race/ethnicity, poverty, employment, income, education and house value
- data_indp_varib_2: same as version "1" but it also includes property and income variables
- data_indp_varib_3: same as version "2" but it also includes urbanicity and epa regions variables
- data_indp_varib_3_inflat_adjs: same as version "3" but includes property and income variables adjusted for inflation to year 2010 dollars
- data_indp_varib_4: same as version 3 inflation adjusted but it includes a county area and population density variable and a variable called "name", which are the county names withou the suffixe "county"
- emissions_all_data: contains emission fluxes for all 7 chemical pollutants for years, 1970, 1980, 1990, 2000, 2010, and 2017. Note that I changed the name of Miami-Dade to Miami so that it would be consistent across the study period
- emissions_diff_reltv_chg: contains emission fluxes, absolute difference and relative change from decennial to decennial. Dade appears as Miami-Dade throughout
- master_data: contains all independent and dependent variables. Dade appears as Miami-Dade throughout 


*Other datasets generated*:
- income_propt_estim1970: property and income estimates for 1970 using aggregated data from the census

*Large datasets generated*:
- geometries_counties: geometries for all counties specific for each decennial year
