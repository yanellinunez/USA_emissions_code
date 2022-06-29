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

# line 2: consider adding epa regions to the title too

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


###############################
## y_04_inflation_adjust.Rmd ##
###############################

# line 51 - Why is 2012 included? Ah I see the answer in line 82. Maybe add a 
#   note around line 51 too?

# line 86 - Why group by year here?


#################################
## y_05_population_density.Rmd ##
#################################

# line 2 - adjust title :)


##################################
## y_06_emissions_data_prep.Rmd ##
##################################

# line 98: Instead of which, I used the code below to id the locations quicker
nh3_agric %>% filter(is.na(nh3_agric))

# line 162: Would it make sense to add a very small value to the 0 concentrations,
#   so that they don't end up being dropped when the result is undefined? I am 
#   thinking this because it may be the counties with 0 original concentrations
#   that have large positive increases. I imagine you have have already
#   considered this, but regardless of choice, consider also adding a sentence
#   or note to the methods about this

# I did not know about lag and lead, so this is very helpful for me!

# line 200: Are the 24 missing observations that are not in the year 2010 all
#   because of having 0 concentrations or infinite values? Also, I assume the
#   larger difference in missing for SO2 is about the values that have a 0 
#   concentration? Consider double checking (if you haven't already),
#   because a few of the missing observations (not for S02) seem to have valid
#   emissions values 
missing1 <- poll_reltv_chg %>% 
  filter(is.na(so2_indus_relat_chg)) %>% 
  filter(year != 2010)
missing2 <- poll_reltv_chg %>% 
  filter(is.na(nox_trans_relat_chg)) %>% 
  filter(year != 2010)
# I see you explore this in the next code chunk! Consider mapping these
# locations? 

# lines 255, 259, and 263: these variables have not yet been created: 
#   nox_trans_chg_med, nh3_agric_chg_med, so2_ener_chg_med

# line 283: Consider adding a dashed horizontal line at 0 to make the facets
#   easier to compare
+ goem_hline(yintercept = 0, linetype = 'dashed')


######################################
## y_07_energy_indus_data_clean.Rmd ##
######################################

# line 150: lol! I always take the long way with missing, NaN, and infinite values!

# lines 172-190: Here, I thought you were going to manually identify each pair
#   of years for which both the numerator and denominator were 0 to confirm that
#   these obs were all the NaN obs present. I don't think you need to, but I'm 
#   not sure why these parts are needed if you do not do that.

# line 200: I am having some trouble following why you use this method for identifying
#   infinite values. What about using is.infinite? Then you don't need to do 
#   lines 193-195, and it would work for ANY infinite values (not just ones 
#   created by dividing by 0 in 2010)
#   https://www.dummies.com/article/technology/programming-web-design/r/how-to-handle-infinity-in-r-141616/
infinite <- data %>% filter(is.infinite(so2_indus_relat_chg))

# line 204: Why remove all county-year observations that had one infinite value?
#   Why not instead only remove the specific years with infinite obs? This would
#   be removing 5 obs instead of removing 25 as you do here


##*************************************************************Models

#################
## functions.R ##
#################

# line 20: In the manuscript you state that Asian and American Native were adjusted
#   for percent white, implying that Hispanic was not. However, I don't see a race
#   model included here without percent white included as a covariate. Okay I see
#   in y_01_single-exp... that you use the econ variable function for hispanic! 
#   Nice!! Maybe clarify this in the header at line 14

# line 20 vs 36: At line 20 you use s(perc_white), but then a natural spline with
#   4 df on line 36. Why the difference? After reading the manuscript section, I
#   get that you use a penalized spline for covariates (in the case of line 20) 
#   but then a natural spline when the variable is an exposure (in the case of line 36)
#   Perhaps add a quick comment in the script to clarify this? It took me a minute
#   to figure out why they were different. 

# line 141: I am confused about why this section is included. Why is there a 
#   cross basis for linear models? Is this where you test everything for non-linearity?

# line 163: Should pred.est be pred_est ? 

# line 220: Was this sensitivity analysis only run for some of the exposures (perc Asian,
#   perc American Indian)? 
#   Asking because s(perc_white) is included in the model, and I don't see other
#   functions with the natural spline or without the perc_white covariate
#   Note: in the manuscript, the methods say that this model was "identical" to the
#   previous, with the exception of the added tensor term

# line 357: Because perc_white is included in the model as a covariate, do you need
#   an additional function for Hispanic where this variable is not included? 


###################################################
## y_01_single-exp_nested_models_ns_mean_ref.Rmd ##
###################################################

# lines 80-93: I find this a bit confusing, because it seems that all the race
#   variables are both non-linear and linear? Is it that they are non-linear
#   for some outcomes and linear for others? I recommend adding some more clarity 
#   here in the notes

# lines 104-112: How did you calculate the mean / where is the code for calculating
#   the means? Consider using a variable for the means and wrapping each exposure
#   input in a paste command. When I try to calculate the mean using 
#   mean(data_full$perc_unemp) or mean(data_master$perc_unemp)I do not get the same value

# line 125: Potential typo in the x_label for Median Property Value (currently 
#   'Median Propty Value ($1000)')

# brilliant set up here with the whole massive function input dataframe!

# lines 160 and 191: It is a little confusing that the comment here includes 'hispanic' even
#   though the models with the hispanic variable aren't included here (but are done
#   with the eco variables)

# Section 2 is included here as a separate piece, but is then repeated again for
# subsequent sections. I'm not sure if it is required ta be repeated or not, but
# I would recommend either keeping it as a separate section OR repeating it with
# each section that is run in parallel

# line 263, 336: Consider changing this comment from "save our work" to "return our work" 
#   because you aren't technically saving, just spitting it out from the function

# line 266: I get the following warning message: 
#   'Warning message:
#    In e$fun(obj, substitute(ex), parent.frame(), e$data) :
#    already exporting variable(s): models_to_make_nonlinear_eco, plot_nonlin, run_model'
#   I looked into this briefly, and it seems fine. I think it is just stating that
#   even though you explicitly set .export, doParallel also found those variables
#   automatically. Seems fine to me, and good to still explicitly set .export. See
#   here for a discussion: https://stackoverflow.com/questions/48243404/doparalleldoparallelsnow-complains-when-foreach-export-is-specified
#   (I get this warning for all doparallel calls)

# line 473: Should this be models_to_make_linear_race? Not such a big deal as its
#   just the progress bar

# line 479: Should this be models_to_make_linear_race? I'm worried this might have
#   dropped out the per_asian SO2 energy model --> yes when I run it, I only get
#   4 observations instead of the 5 I should have, and reviewing the summaries shows
#   that the asian S02 energy model is missing.
#   To continue with the review I just replaced the dataframes with 
#   models_to_make_linear_race in the console, but leave it to you to update the 
#   script itself (just in case I am missing something) 

# line 528: wrong dataframe listed for progress bar

# About the progress bar: I do not see it working in my console for the non-parallelized 
# sections even when it is invoked. I think remove from those sections becuase it
# doesn't seem to be working and those sections run pretty fast anyway


###############################################
## y_02_sensitiv_analys_models_adjus_eco.Rmd ##
###############################################

# line 2: Consider changing the title in the floating header to reflect that the
#   sensitivity analyses are adjusting for eco vars

# lines 54-55: Why do you only review summaries for some dataframes? I'm just
#   curious

# line 143: Here I would rephrase the comment from "save" our work to "return" our
#   work, just because the model isn't saved to a file here

#Jenni: run from line 124 tonight


#############################################
## y_03_sesitiv_analys_regional_models.Rmd ##
#############################################

# lines 73-86: Instead of adding all 7 sectors, you could just add the 2 you need
#   here, and then delete line 106. This would save you several lines of code

# line 98: the 'add outcome column' note should be deleted here, as it does not apply


# Where do you run the spatial sensitivity analyses? 


#######################################
## y_04_extract_effect_estimates.Rmd ##
#######################################

# line 54: Am I right that the order here must match the order in the linear_models
#   df? if this is true, consider building the cb names again using what is available
#   in linear_models rather than manually writing them in. This would make the code
#   more robust to potential errors. Not such a big deal though,
#   they are all in the correct order.


##*************************************************************Figures

########################################
## y_01_plot_models_main_analysis.Rmd ##
########################################

# line 157: Consider adding a note to this plot that median family income is
#   adjusted to 2010 US dollars (correct?)

# line 165: Typo in x-label; "Propty" should be "Property"

# code chunk starting on line 230 (econ main results): labels in the plot I run 
#   compared to your final plot are not the same (for x and y axis and for exposures / outcomes)
#   I will send you mine so you can see them as well. I assume you fixed up the 
#   labels in PP? All the curves look the same to me

# line 321 (dens_hispanic): Recieve this warning when running plot: 
#   Removed 1 rows containing non-finite values (stat_density). 
#   Not sure why one row should be removed or if this is important?

# same comment as above for code chunk starting on line 364 (race main results)
#   also received this warning: "Removed 1 row(s) containing missing values (geom_path)." 
#   for seven geom_paths. Maybe these are all about the same row from % hispanic
#   that is dropped in the density plot? Also, in your version of this plot, you
#   labeled effect estimates for some plots. I find this a bit confusing actually
#   because it isn't clear why those plots have the estimates on them (and a person
#   might infer something about statistical significance from that)


#####################
## y_02_tables.Rmd ##
#####################

# line 2: Consider adjusting the title 

# table 1: Why no 1980?

# table 2: The air pollutants are not in the same order when you run them in R
#  as the table in the manuscript (not that this really matters, just flagging it)

# If you keep the Net Relative Change and Absolute Change in Table 2 in the 
# manuscript, be sure to add the code to this file


#############################
## y_03_emissions_maps.Rmd ##
#############################

# lines 297-319: This is duplicated; NOx transport is done in the code chunk above

# Can you send me the emissions maps created in this file? I don't see them in 
# the materials I have. 


#################################################
## y_04_sensit_analys_plot_models_adjs_eco.Rmd ##
#################################################

# line 59 and on: For each of these plots, I get the error "Error in plot.new():
#   figure margins too large. I'm not able to run any of the plots. Also, is there 
#   code missing at the end for dev.off() or anything like that?


###########################################
## y_05_sensitv_analy_regional_plots.Rmd ##
###########################################

# I don't have a copy of these plots, but I will send you the versions I created so
# you can compare. 

# line 174: Consider adding some explanation here about what you are checking for
#   in the code chunk below. (I'm also not sure what you are checking for)

# line 188: I get the error about plot margins here too "Error in plot.new(): figure
#   margins too large





