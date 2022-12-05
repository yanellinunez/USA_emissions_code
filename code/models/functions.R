

# This R script contains all functions require to run the analyses models 
# The script is called in the first code chunk in each of the .rmds so no need run separately 

######################
## Models Functions ##
######################

######################
## A. Race models   ##
######################

### A1. Function to run linear/nonlinear models race

run_model_race <- function(data, outcome, exposure) {
  
  
  model_t = gamm4::gamm4(as.formula(paste(outcome, "~", exposure, " +
                                            s(perc_white) +
                                            epa_reg +
                                            s(pop_density) +
                                            urbanicity +
                                            year")), 
                         random = ~(1|state/gisjoin), data = get(data)) # use get to call the data with the name
  model_t[["gam"]]
  
}

### A2. Function to run linear/nonlinear models race black

run_model_blk <- function(data, outcome, exposure) {
  
  
  model_t = gamm4::gamm4(as.formula(paste(outcome, "~", exposure, " +
                                            Ns(perc_white, df = 4, ref = 87.58) +
                                            epa_reg +
                                            s(pop_density) +
                                            urbanicity +
                                            year")), 
                         random = ~(1|state/gisjoin), data = get(data)) # use get to call the data with the name
  model_t[["gam"]]
  
}

########################
## B. Economic models ##
########################

### B1. Function to run linear/nonlinear models economic 

run_model <- function(data, outcome, exposure) {
  
  
  model_t = gamm4::gamm4(as.formula(paste(outcome, "~", exposure, " +
                                            epa_reg +
                                            s(pop_density) +
                                            urbanicity +
                                            year")), 
                         random = ~(1|state/gisjoin), data = get(data)) # use get to call the data with the name
  model_t[["gam"]]
  
}


################################################
## C. Predict & Plot Nonlinear Relationships ###
################################################

### C4. Predict and Plot nonlinear dose-response for percent white 

plot_nonlin_white <- function(model, data, color) {
  
  # predict 
  pred <- predict(model, se.fit = TRUE, type = "terms") 
  
  # polish predictions
  pred_df <- tibble(pred$fit[,2], pred$se.fit[,2], get(data)[, 'perc_white']) %>%
    as.data.frame() %>%
    clean_names()  %>%
    dplyr::rename(indp_var = 3,
                  beta = pred_fit_2,
                  se = pred_se_fit_2) %>%
    arrange(indp_var) %>%
    mutate(lci = beta - 1.96 * se,
           uci = beta + 1.96 * se)
  
  
  # plot
  plot <- pred_df %>%
    ggplot(aes(x = indp_var)) +
    theme_minimal(base_size = 15) +
    geom_ribbon(aes(ymin = lci, ymax = uci), fill = color, alpha = 0.3) +
    geom_path(aes(y = beta), size = 0.7) +
    geom_hline(yintercept = 0, linetype = 2, size =0.5) +
    xlab("% White") +
    ylab("")
  # geom_rug(sides = "b")
  
  plot
  
}


### C3. Predict and Plot nonlinear relationships


plot_nonlin <- function(model, data, exposure, x_label, color) {

# predict 
pred <- predict(model, se.fit = TRUE, type = "terms") 

# polish predictions
pred_df <- tibble(pred$fit[,1], pred$se.fit[,1], get(data)[, exposure]) %>%
  as.data.frame() %>%
  clean_names()  %>%
  dplyr::rename(indp_var = 3,
                beta = pred_fit_1,
                se = pred_se_fit_1) %>%
  arrange(indp_var) %>%
  mutate(lci = beta - 1.96 * se,
         uci = beta + 1.96 * se)


# plot
plot <- pred_df %>%
  ggplot(aes(x = indp_var)) +
  theme_minimal(base_size = 15) +
  geom_ribbon(aes(ymin = lci, ymax = uci), fill = color, alpha = 0.3) +
  geom_path(aes(y = beta), size = 0.7) +
  geom_hline(yintercept = 0, linetype = 2, size =0.5) +
  xlab(x_label) +
  ylab("")

plot
  
}


##############################################
## D. Function for linear models w/onebasis ##
##############################################

### D1. Function for onebasis

one_basis <- function(data, exposure){
  
  cb <- onebasis(
    # the column with the exposure 
    x = get(data)[, exposure],         
    # the functional form of the constraint on the exposure dimension
    fun = "lin")
 
  cb
   
}


### D2. Predict and plot from onebasis linear relationships

plot_linear <- function(pred_est, x_label, color) {
  
 # pred.est <- crosspred(
 #   # the exposure crossbasis
 #   basis = basis, #### the basis argument isn't working. I don't know why 
 #   # the model
 #   model = model[[2]], 
 #   at = data[, exposure], 
 #   cen = reference) 
  
  
# i Extract fit
  pred_inf <- get(pred_est)
  
  fit <- as_tibble(pred_inf$matfit, rownames = NA) %>%
    tibble::rownames_to_column(., "indp_var") %>%
    rename(beta = lag0) 
  
  # ii Extract 95% CI  
  lci <- as_tibble(pred_inf$matlow, rownames = NA) %>%
    tibble::rownames_to_column(., "indp_var") %>%
    rename(lci = lag0) 
  
  uci <- as_tibble(pred_inf$mathigh, rownames = NA) %>%
    tibble::rownames_to_column(., "indp_var") %>%
    rename(uci = lag0) 
  
  # iii Combine fit and se 
  table_full <- left_join(fit, lci) %>%
    left_join(., uci)  %>%
    dplyr::mutate(indp_var = as.numeric(indp_var))
  
  
  # iv Plot
   plot <- table_full %>%
    ggplot(aes(x = indp_var)) +
    theme_minimal(base_size = 15) +
    geom_ribbon(aes(ymin = lci, ymax = uci), fill= color, alpha = 0.3) +
    geom_path(aes(y = beta), size = 0.7) +
    geom_hline(yintercept = 0, linetype = 2, size =0.5) +
    xlab(x_label) +
    ylab("")
  
  plot

}


####################################
## Sensitivity Analyses Functions ##
####################################

########################
## E. Spatial models ###
########################

### E1 Function to run linear/nonlinear model spatial (tensor product) 


run_model_sp <- function(data, outcome, exposure) {
  
  
  model_t = gamm4::gamm4(as.formula(paste(outcome, "~", exposure, " +
                                            s(perc_white) +
                                            epa_reg +
                                            s(pop_density) +
                                            urbanicity +
                                            t2(lat,long) +
                                            year")), 
                         random = ~(1|state/gisjoin), data = get(data)) # use get to call the data with the name
  model_t[["gam"]]
  
}


########################
## F. Regional models ##
########################

### F1. Function to run regional models 
# Independent variable includes a penalized spline 

reg_model_func <- function(data, epa_region, outcome, exposure) {
  
  model <- get(data) %>%
    filter(epa_reg == epa_region) %>%
    gamm4::gamm4(as.formula(paste(outcome, "~ s(", exposure, ") +
                                s(pop_density) +
                                urbanicity +
                                year")), 
                 random = ~(1|state/gisjoin), data = .)
  
  model[["gam"]]
  
}

### F2. Function to run regional penalized models for RACE 
# Independent variable includes a penalized spline
# Unlike D1, this model is adjusted for percent white

reg_model_func_race <- function(data, epa_region, outcome, exposure) {
  
  model <- get(data) %>%
    filter(epa_reg == epa_region) %>%
    gamm4::gamm4(as.formula(paste(outcome, "~ s(", exposure, ") +
                                s(perc_white) +
                                s(pop_density) +
                                urbanicity +
                                year")), 
                 random = ~(1|state/gisjoin), data = .)
  
  model[["gam"]]
  
}

### F3. Predict and Plot Regional Nonlinear relationships 


plot_nonlin_regional <- function(model, data, region, exposure, color, x_label, title) {
  
  # predict 
  pred <- predict(model, se.fit = TRUE, type = "terms") 
  
  # polish predictions
  pred_df <- get(data) %>% 
    dplyr::filter(epa_reg == region) %>%
    dplyr::select(exposure) %>%
    tibble(., pred$fit[,3], pred$se.fit[,3]) %>%
    as.data.frame() %>%
    clean_names()  %>%
    dplyr::rename(indp_var = 1,
                  beta = pred_fit_3,
                  se = pred_se_fit_3) %>%
    arrange(indp_var) %>%
    mutate(lci = beta - 1.96 * se,
           uci = beta + 1.96 * se)
  
  
  # plot
  plot <- pred_df %>%
    ggplot(aes(x = indp_var)) +
    theme_minimal() +
    geom_ribbon(aes(ymin = lci, ymax = uci), fill = color, alpha = 0.3) +
    geom_path(aes(y = beta), size = 0.7) +
    geom_hline(yintercept = 0, linetype = 2, size =0.5) +
    xlab(x_label) +
    ylab("") +
    ggtitle(title)
  # geom_rug(sides = "b")
  plot
  
}


### F4. Predict and Plot Regional Nonlinear relationships WHITE 

plot_nonlin_regional_wt <- function(model, data, region, color, title) {
  
  # predict 
  pred <- predict(model, se.fit = TRUE, type = "terms") 
  
  
  # polish predictions
  pred_df <- get(data) %>% 
    dplyr::filter(epa_reg == region) %>%
    dplyr::select(perc_white) %>%
    tibble(., pred$fit[,4], pred$se.fit[,4]) %>%
    as.data.frame() %>%
    clean_names()  %>%
    dplyr::rename(indp_var = 1,
                  beta = pred_fit_4,
                  se = pred_se_fit_4) %>%
    arrange(indp_var) %>%
    mutate(lci = beta - 1.96 * se,
           uci = beta + 1.96 * se)
  
  
  # plot
  plot <- pred_df %>%
    ggplot(aes(x = indp_var)) +
    theme_minimal() +
    geom_ribbon(aes(ymin = lci, ymax = uci), fill = color, alpha = 0.3) +
    geom_path(aes(y = beta), size = 0.7) +
    geom_hline(yintercept = 0, linetype = 2, size =0.5) +
    xlab("% White") +
    ylab("") +
    ggtitle(title)
  plot
  
}


########################################################
## G. Race models adjusting for confounding by income ##
########################################################

### G1. All eco variables in racial models 

run_model_eco_adjus <- function(data, outcome, exposure) {
  
  
  model_t = gamm4::gamm4(as.formula(paste(outcome, "~", exposure, " +
                                            s(perc_white) +
                                            s(perc_pvert) +
                                            s(perc_unemp) +
                                            s(fam_incom_adjs) +
                                            s(propty_val_adjs) +
                                            epa_reg +
                                            s(pop_density) +
                                            urbanicity +
                                            year")), 
                         random = ~(1|state/gisjoin), data = get(data)) # use get to call the data with the name
  model_t[["gam"]]
  
}

###############
## H. Others ##
###############

### H1. Extracting coefficients from linear models


beta_extrc <- function(index, indep_var) {
  
  #extract beta and standard errors
  
  table <- get_coefs(linear_models$models[[index]]) %>%
    as.data.frame() %>%
    tibble::rownames_to_column(., "variable") %>%
    filter(variable == indep_var) %>%
    clean_names() 
  
  table
  
}

