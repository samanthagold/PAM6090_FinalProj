library(compareGroups)
# Purpose -----------------------------------------------------------------
## The purpose of this script is to generate descriptive stats tables taht 
## describes our data. 

outdir <- "data/processed/"
data <- read_csv(paste0(outdir, "HPS_all.csv"), 
                 show_col_types = FALSE, 
                 progress = FALSE)
final_sample <- read_csv(paste0(outdir, "final_sample_treatment.csv"), 
                         show_col_types = FALSE, 
                         progress = FALSE)
# Generating Table -------------------------------------------------------
table_data <- data %>% 
    rename_with(~tolower(.x), .cols = everything()) %>% 
    mutate(Group = "1:No Sample Restrictions") %>% 
    bind_rows(final_sample %>% 
                  filter(!is.na(treat)) %>% 
                  mutate(Group = "2:All Sample Restrictions")) %>% 
    bind_rows(final_sample %>%
                  filter(treat == 1) %>% 
                  mutate(Group = "3:Treatment")) %>% 
    bind_rows(final_sample %>%
                  filter(treat == 0) %>% 
                  mutate(Group = "4:Control")) %>%
    mutate(
        Income = case_when(income == 1 ~ "Less than 25K", 
                           income == 2 ~ "25K-34.9K", 
                           income == 3 ~ "35K-49.9K", 
                           income == 4 ~ "50K-74.9K", 
                           income == 5 ~ "75K-99.9K", 
                           income == 6 ~ "100K-149.9K", 
                           income == 7 ~ "150K-199.9K", 
                           income == 8 ~ "200K+", 
                           TRUE ~ NA_character_), 
        Race = case_when(rrace == 1 ~ "White",
                         rrace == 2 ~ "Black", 
                         rrace == 3 ~ "Asian", 
                         rrace == 4 ~ "Other"), 
        Hispanic = case_when(rhispanic == 1 ~ "No", 
                             rhispanic == 2 ~ "Yes"), 
        Education = case_when(eeduc == 1 ~ "Less than HS", 
                              eeduc == 2 ~ "Some HS", 
                              eeduc == 3 ~ "HS Grad", 
                              eeduc == 4 ~ "Some College", 
                              eeduc == 5 ~ "AA Degree", 
                              eeduc == 6 ~ "BA Degree", 
                              eeduc == 7 ~ "Grad Degree"), 
        `Marital Status` = case_when(ms == 1 ~ "Married", 
                                     ms == 2 ~ "Widowed", 
                                     ms == 3 ~ "Divorced", 
                                     ms == 4 ~ "Separated", 
                                     ms == 5 ~ "Never Married", 
                                     TRUE ~ NA_character_), 
        across(c(Race, Hispanic, Education, `Marital Status`, Income), factor), 
        Income = fct_reorder(Income, income), 
        Race = fct_reorder(Race, rrace), 
        Hispanic = fct_reorder(Hispanic, rhispanic), 
        Education = fct_reorder(Education, eeduc), 
        `Marital Status` = fct_reorder(`Marital Status`, ms), 
        Week = week
        ) %>% 
    rename(`Total Kids` = thhld_numkid) 
        
    
rm(data, final_sample)



sumStats <- table_data %>% 
    # Selecting relevant demographic variables
    select(Group, Race, Hispanic, Education, `Marital Status`, Income, `Total Kids`, Week) %>% 
    # Note: method = c(Week = 2) is telling CompareGroups to report the min and max values 
    compareGroups(formula = Group ~ ., 
                  method = c(Week = 2), Q1 = 0 , Q3 = 1) 


table <- createTable(sumStats, show.p.overall = FALSE)

expand_factor <- function(data, var){
    if(is.factor(data %>% pull(var))){
        distinct_values <- data %>% pull(var) %>% unique()
        for(v in distinct_values){
            if(!is.na(v)){
                data <- data %>% 
                    mutate(!!paste0(var, "_", v) := case_when(get(var) == v ~ 1, 
                                                              TRUE ~ 0))
                
            } else {
                data <- data %>% 
                    mutate(!!paste0(var, "_", v) := case_when(is.na(get(var)) ~ 1, 
                                                              TRUE ~ 0))
            }
            
        }
        
    } else { 
        next 
        
    }
    return(data)
}
sumstats_treatment <- table_data %>% 
    # Selecting relevant demographic variables
    select(Group, Race, Hispanic, Education, `Marital Status`, Income, `Total Kids`, Week)  %>% 
    filter(Group == "3:Treatment" | Group == "4:Control") %>% 
    expand_factor("Race") %>% 
    expand_factor("Hispanic") %>% 
    expand_factor("Education") %>% 
    expand_factor("Income") %>% 
    compareGroups(formula = Group ~ ., 
                  method = c(Week = 2), Q1 = 0, Q3 = 1, p.corrected = FALSE)

table_treatment <- createTable(sumstats_treatment, show.p.overall = TRUE)


# Getting Latex Code
#export2latex(table)

# Getting Word Doc 
export2word(table, file = tempfile(fileext=".docx"))
