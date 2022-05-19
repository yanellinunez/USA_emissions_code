## Code Review 
## Trends in Air Pollution Emissions in the Contiguous United 
## States from 1970 to 2010: An Environmental Justice Analysis
## Jenni A. Shearston
## Updated: May 17, 2022


## Overall Notes:
# I reviewed code in the 'code' sub-folder only


##*************************************************************Packages & Data Loading

########################
## packages_to_load.R ##
########################

# No suggestions or comments, other than this is a cool way to deal with packages!


####################
## data_loading.R ##
####################

# Typos on line 3 with spelling of 'Yellowstone' and 'property'

# I note here that so2_inds, so2_energy, and nox_energy do not have mutate
#   statements to make epa_reg and year factors (I am not sure if this is needed)

# Why are only some sector-pollutant combinations separate datasets? Consider
#   adding a note in the script to clarify.


##*************************************************************Data Exploration

###########################
## y_01_correlations.Rmd ##
###########################

# line 47: It appears here that you are only dividing by the standard deviation,
#   and not first subtracting the mean and then dividing by the standard deviation.
#   Is there a reason for this? I do not mean to suggest that you are wrong, but 
#   rather I have just seen subtracting the mean first in the past, so wanted to
#   flag this for your review. 

# line 66: Does it make sense to consider also doing correlations for each year 
#   separately (1970, 1980, 1990, 2000)? No idea here, I was just wondering.

# line 75: typo for spelling of 'right'

# line 87: Can you add a space between the percent sign and the word after it, for
#   each of the percent variable names? 

# line 93: Why not set the midpoint to 0, instead of 0.5? I find 0.5 to be a quite
#   confusing, because visually it makes the legend bar look unbalanced, and also
#   it is more intuitive for negatives to be one color and positives another. Also, if 
#   possible, I think it would be good to add -1 as the min, to balance the +1 on
#   the other side of the legend bar

# Overall: If publishing code with the manuscript, consider removing the hashtagged  
#  code that is no longer used throughout this script (e.g., lines 51, 73, etc) 


##*************************************************************Data Prep

###############################
## y_01_census_data_prep.Rmd ##
###############################

# lines 98-100: As education is not used, I do not think this is critical to 
#   change, but wanted to note it in case education does get used at some 
#   future point. Because of the way the education variables changed from 1970
#   to 2010, I would be very careful about how you define these categories in 
#   the text of the manuscript, as some college is mixed with high school
#   graduate, etc

# line 197: When was Skagway-Yakutat-Angoon discontinued?

# line 283: What does "low exposure contrasts mean"? Maybe clarify just a touch
#   more here, if the code will be included in the manuscript. I'm unclear because
#   Delaware, for example, has even fewer counties than Hawaii.

# code chunk starting at line 308: Just a note that variables for 
#   countynh and statenh for median house income and median family income are
#   not included

# line 412: Double check your choice of denominator here for perc_nohs -- I think this
#   is usually divided by the total population aged 25 and older, because total_pop
#   includes children who cannot yet have a high school degree, and this falsely
#   inflates the percentage

# line 422: the max for perc_hisp_org is greater than 100 (117.6991)

# line 435: Confirming n=15546 is correct; 15781 possible county-year observations, 
#   minus 78 counties for Puerto Rico in 2010 only, 4+5+5+5+5=24 counties for Hawaii 
#   and 29+23+25+27+29=133 for Alaska


################################
## y_02_incom_prptry_1970.Rmd ##
################################

# lines 80, 92, 106: Noting that the county variable was not selected here

# line 147: I get an error with this mutate statement beause there isn't a variable
#   called "county" --> in the join they became county.x and county.y

# line 186: Move package to packages_to_load.R?

# line 189: the variable sum_agg_incom doesn't exist and is causing an error here

# line 201: Woah, what's up with Colorado, New York, and Virgina?! Also noting
#   that 4 rows were dropped with missing data, and I think the axis labels are
#   reversed. Please also double check whether the labels should be mean or median,
#   one label read "media" which I changed to median, but I'm not sure this is correct

# line 309: mean_fam_income_variable has not been created, so cannot be joined


#####################################
## y_03_urbanicity_epa_regions.Rmd ##
#####################################

# code chunk starting at line 70: In this situation, I prefer to use case_when
#   instead of nested ifelse statements. When I tried running both versions, the
#   case_when version ran faster as well (though that could be something up
#   with my computer lol). It would look like this:
data_urbanicity <- data  %>%
  mutate(urbanicity = as.factor(case_when(
    tot_pop >= 50000                   ~ 'metropolitan',
    tot_pop < 50000 & tot_pop >= 10000 ~ 'micropolitan',
    tot_pop < 10000                    ~ 'non-urban'
  )))
# Ah I see you use case_when right below!










