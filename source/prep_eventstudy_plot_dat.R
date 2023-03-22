
# Purpose -----------------------------------------------------------------
    # Getting reg output into proper format for graphing in stata 


# Housekeeping ------------------------------------------------------------
library(tidyverse)
fp <- "tables/main_reg_spec.txt"



# Data Prep ---------------------------------------------------------------
read_delim(fp, col_names = c("var", "foodsecure", "foodsecure_high"), 
           show_col_types = FALSE, 
           progress = FALSE) %>% 
    slice(-c(1:2)) %>% 
    select(1:3) %>% 
    fill(var, .direction = "down") %>% 
    mutate(event_var = case_when(str_detect(var, "ED") ~ 1, TRUE ~ 0)) %>% 
    filter(event_var == 1) %>% 
    mutate(est_type = case_when(str_detect(foodsecure, "\\(") ~ "se", TRUE ~ "coef"),            
           event = parse_number(var), 
           event = case_when(str_detect(var, "m") ~ event *-1, 
                             TRUE ~ event), 
           foodsecure = parse_number(foodsecure), 
           foodsecure_high = parse_number(foodsecure_high)) %>% 
    select(event, foodsecure, foodsecure_high, est_type) %>% 
    pivot_wider(id_cols = c(event), 
                names_from = est_type, 
                values_from = c(foodsecure, foodsecure_high)) %>% 
    mutate(foodsecure_upper = foodsecure_coef + qnorm(0.95)*foodsecure_se, 
           foodsecure_lower = foodsecure_coef - qnorm(0.95)*foodsecure_se, 
           foodsecure_high_upper = foodsecure_high_coef + qnorm(0.95)*foodsecure_high_se, 
           foodsecure_high_lower = foodsecure_high_coef - qnorm(0.95)*foodsecure_high_se) %>% 
    rename(etime = event, 
           ES_b = foodsecure_coef, 
           ES_b_upper = foodsecure_upper, 
           ES_b_lower = foodsecure_lower,
           ES_b2 = foodsecure_high_coef, 
           ES_b2_upper = foodsecure_high_upper, 
           ES_b2_lower = foodsecure_high_lower) %>% 
    select(-contains("se")) %>% 
    haven::write_dta("data/processed/event_study_plots_w_CI.dta")

