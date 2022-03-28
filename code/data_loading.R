
# Data loading
# Removed Yellow Stone because it has a negative propty value. It has a very low population anyways
# There are a number of counties (small islands) for which we do not have emissions data, 
# I removed those counties too

data_master <- readRDS(paste0(data.folder, "generated_data/master_data.rds")) %>% 
  mutate(gisjoin = as.factor(gisjoin)) %>%
  filter(year != 2010,
         county != "Yellowstone National Park") %>%
  drop_na(nox_trans_relat_chg, propty_val_adjs, fam_incom_adjs, perc_asian) %>%
  arrange(year) %>%
  mutate(epa_reg = as.factor(epa_reg),
         year = as.factor(year))



so2_inds <- readRDS(paste0(data.folder, "generated_data/master_so2_industry.rds")) %>% 
  mutate(gisjoin = as.factor(gisjoin),
         epa_reg = as.factor(epa_reg)) %>%
  filter(year != 2010,
         county != "Yellowstone National Park") %>%
  drop_na(so2_indus_relat_chg, propty_val_adjs, fam_incom_adjs, perc_asian) %>%
  arrange(year) 



so2_energy <- readRDS(paste0(data.folder, "generated_data/master_so2_energy.rds")) %>% 
  mutate(gisjoin = as.factor(gisjoin),
         epa_reg = as.factor(epa_reg)) %>%
  filter(year != 2010,
         county != "Yellowstone National Park") %>%
  drop_na(so2_energy_relat_chg, propty_val_adjs, fam_incom_adjs, perc_asian) %>%
  arrange(year) 



nox_energy <- readRDS(paste0(data.folder, "generated_data/master_nox_energy.rds")) %>% 
  mutate(gisjoin = as.factor(gisjoin),
         epa_reg = as.factor(epa_reg)) %>%
  filter(year != 2010,
         county != "Yellowstone National Park") %>%
  drop_na(nox_energy_relat_chg, propty_val_adjs, fam_incom_adjs, perc_asian) %>%
  arrange(year) 

