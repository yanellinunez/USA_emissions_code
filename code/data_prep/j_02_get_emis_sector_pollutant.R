# title: "j_02_get_emis_sector_pollutant"
# author: "Jaime Benavides"
# date: "2/23/2021"
# script aim: get emissions for US in original CEDS netcdf to an R object

rm(list=ls())

# 1a Declare root directory

project.folder <- paste0(print(here::here()),'/')

# add folder locations
source(paste0(project.folder,'0_00_create_folder_structure.R'))

# add file locations
#source(paste0(file.locations.folder,'file_locations.R'))

# load packages
source(paste0(packages.folder,'packages_to_load.R'))

### 1. download emissions from https://zenodo.org/record/3754964#.YliTAnXMJH4
# need to download two compressed files:
# 1. CEDS_GBD-MAPS_BC_OC_gridded_total_anthro_emissions_by_sector_input4CMIP_1970-2017.zip
# 2. CEDS_GBD-MAPS_CO_NOx_SO2_NH3_gridded_total_anthro_emissions_by_sector_input4CMIP_1970-2017.zip
# unzip compressed files and store all the downloaded files in the folder USA_emissions_code/data/emissions_data/
# also download an example of the grid used in CEDS from http://www.globalchange.umd.edu/ceds/ceds-cmip6-data/ by 

grid_file_path <- paste0(data.folder, "emissions_data/", "CEDS_gridcell_area_05.nc") # downloaded from http://www.globalchange.umd.edu/ceds/ceds-cmip6-data/ and available at USA_emissions_code/data/emissions_data/

### 2.  choose pollutant (character) and sector (number)
# in this study you need to generate all the following combinations 
# pollutant: "NOx" sector_of_interest: 2 sector_name: ener (Energy)
# pollutant: "NOx" sector_of_interest: 4 sector_name: tr (On-road transport)
# pollutant: "NOx" sector_of_interest: 7 sector_name: commercial (Commercial combustion)
# pollutant: "SO2" sector_of_interest: 2 sector_name: ener (Energy)
# pollutant: "SO2" sector_of_interest: 3 sector_name: industry (Industry)
# pollutant: "NH3" sector_of_interest: 1 sector_name:  agric (Agriculture)
# pollutant: "OC" sector_of_interest: 6 sector_name: residential (Residential Combustion)

# choose pollutant
pollutant <- "SO2" # in this example we use SO2, we also need to run the previous combinations

# choosing sector 
sector_of_interest <- 2 # (example made with energy, sector 2)
sector_name <- "ener"
# sector of interest options:
# 1. Agriculture (non-combustion sources only, excludes open fires)
# 2. Energy (transformation and extraction)
# 3. Industry (combustion and non-combustion processes)
# 4. On-Road Transportation
# 5. Non-Road/Off-Road Transportation (rail, domestic navigation, other)
# 6. Residential Combustion
# 7. Commercial Combustion
# 8. Other Combustion
# 9. Solvent production and application
# 10. Waste (disposal and handling)
# 11. International Shipping (including VOCs from oil tanker loading/leakage)

# build file name
emis_file_name <- paste0(pollutant, "-em-total-anthro_input4CMIP_emissions_CEDS-2020-v1_gn_197001-201712.nc")



# set crs
crs_wgs84 <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"


### 3. load data

# demography data
us_boundaries <- sf::st_read(paste0(data.folder, "geometries/cb_2018_us_nation_20m.shp")) %>%
  sf::st_transform(crs_wgs84)

# emissions
poll_emis_netcdf <- RNetCDF::open.nc(paste0(data.folder, "emissions_data/", emis_file_name))
RNetCDF::print.nc(poll_emis_netcdf)


### 4. get centroids falling within US 

# find all centroids within netcdf
lat_ncdf <- RNetCDF::var.get.nc(poll_emis_netcdf, "lat") 
lon_ncdf <- RNetCDF::var.get.nc(poll_emis_netcdf, "lon")
inst <- length(lat_ncdf[ ]) * length(lat_ncdf[])
i_all = j_all = integer(inst)
lat_all = lon_all = numeric(inst)
k <- 1
for (i in 1:length(lon_ncdf[])) {
  for (j in 1:length(lat_ncdf[ ])) {
    i_all[k] <- i
    j_all[k] <- j
    lon_all[k] <- lon_ncdf[i]
    lat_all[k] <- lat_ncdf[j]
    k <- k + 1
  }
}
centroids <- data.frame(i = i_all, j = j_all, lat = lat_all, lon = lon_all)
xy <- centroids[,c(4,3)]
centroids <- sp::SpatialPointsDataFrame(coords = xy, data = centroids, proj4string = sp::CRS(crs_wgs84))
centroids_sf <- sf::st_as_sf(centroids)
centroids_df <- as.data.frame(centroids_sf)

# restrict centroids to those over US
centroids_sf__within_us <- centroids_sf[us_boundaries,]

centroids_us_df <- centroids_sf__within_us
sf::st_geometry(centroids_us_df) <- NULL

# create a rectangular grid of centroids containing US 
centroids_sf_us_domain <- centroids_sf[centroids_sf$i >= (min(centroids_us_df[,"i"])-2) & centroids_sf$i <= (max(centroids_us_df[,"i"])+2) &
                                    centroids_sf$j >= (min(centroids_us_df[,"j"])-2) & centroids_sf$j <= (max(centroids_us_df[,"j"])+2), ]

# create mask for centroids falling within the us
centroids_us_df$within_us <- "Y"
centroids_sf_us_domain <- dplyr::left_join(centroids_sf_us_domain, centroids_us_df)
centroids_sf_us_domain[is.na(centroids_sf_us_domain$within_us), "within_us"] <- "N"

# set id for centroids 
centroids_sf_us_domain$id <- 1:nrow(centroids_sf_us_domain)

### 5. create dataframe for the chosen pollutant emissions from chosen sector that has rows for dates and columns for centroids_ids

# obtain time series contained in the netcdf
time_netcdf <- RNetCDF::var.get.nc(poll_emis_netcdf, "time")
origin <- as.Date("1750-01-01", format = "%Y-%m-%d")
seconds_per_day <- 24 * 60 * 60
date <- as.POSIXct(PCICt::as.PCICt(time_netcdf * seconds_per_day, origin = "1750-01-01", tz = "UTC", cal="365_day"), tz = "UTC")

# create the sf object that contains centroids information, and the summary variables for each centroid (this step may take long, about 10 or more hours)
emis_all <- data.frame(date = date)
for (c in 1:nrow(centroids_sf_us_domain)){
  d <- c 
  print(paste0("d is ", d))
  if(centroids_sf_us_domain$within_us[d] == "Y"){

emis <- RNetCDF::var.get.nc(poll_emis_netcdf, paste0(pollutant, "_em_anthro"), 
                            start = c(centroids_sf_us_domain$i[d],centroids_sf_us_domain$j[d], sector_of_interest, 1), count = c(1, 1, 1, 576),
                            unpack = TRUE)
}else{
emis <- rep(0,nrow(emis_all))
}
  emis_all[,(1+c)] <- emis
  colnames(emis_all)[(1+c)] <- paste0("c_", centroids_sf_us_domain$id[d])
}
# save intermediate dataset containing emissions per year in raw form
saveRDS(emis_all, paste0(data.folder, "emissions_data/", "emis", tolower(pollutant), "_", sector_name, "_us.rds"))

### 6. change units: from monthly average flux in kg m-2 s-1 to kg km-2 day-1
# from seconds to days
emis_all[,-1] <- emis_all[,-1] * 60 * 60 * 24
# from m-2 to km-2
emis_all[,-1] <- emis_all[,-1] * 1e+06

### 7. estimate annual emissions per centroid over US
emis_annual_avg_flow <- emis_all %>%
  dplyr::mutate(year = format(date, "%Y")) %>%
  dplyr::group_by(year) %>%
  dplyr::summarise_at(vars(-date), mean)


### 8. initiate a dataframe to allocate emissions for each centroid and year
emis_summary_vars <- centroids_sf_us_domain

for(y in 1:nrow(emis_annual_avg_flow)){
  year_eval <- as.character(emis_annual_avg_flow[y,1])
  nam <- year_eval
  emis_summary_vars[,(ncol(emis_summary_vars)+1)] <- as.numeric(emis_annual_avg_flow[emis_annual_avg_flow$year == as.numeric(year_eval),2:ncol(emis_annual_avg_flow)])
  colnames(emis_summary_vars)[ncol(emis_summary_vars)] <- nam
  # assing na to centroids not falling within US
  emis_summary_vars[emis_summary_vars$within_us == "N", nam] <- NA
}

### 9. save data
saveRDS(emis_summary_vars, paste0(data.folder, "emissions_data/", "emis_", tolower(pollutant), "_",  sector_name, "_centroids.rds"))
