

# list of packages to use
list.of.packages = c('tidyverse', 
                     'haven',
                     'ggplot2',
                     'GGally',
                     'caret',
                     'readr',
                     'raster', 
                     'nortest',
                     'MASS',
                     'extrafont', 
                     'forestplot',
                     'ggsn',
                     'survival',
                     'grid',
                     'gridExtra', 
                     'cowplot',
                     'reshape2',
                     'naniar',
                     'rpart',
                     'rpart.plot',
                     'pROC',
                     'car',
                     'olsrr',
                     'EnvStats',
                     'janitor',
                     'tableone', 
                     'reshape',
                     'sf', 
                     'areal', 
                     'mgcv',
                     'gamm4', 
                     'rgeos', 
                     'spdep', 
                     'gstat',
                     'splines',
                     'Epi', # the Ns function is from the Epi package 
                     'dlnm',
                     'foreach', # for looping
                     'gtsummary',
                     'here', # for making tables
                     'scales',
                     'leaflet',
                     'PCICt',
                     "RNetCDF")

# check if list of packages is installed. If not, it will install ones not yet installed
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# load packages
lapply(list.of.packages, require, character.only = TRUE)




