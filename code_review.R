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









