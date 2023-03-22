# Purpose -----------------------------------------------------------------
    # This script combines all weekly data from the PULSE files and then 
    # outputs final files: 
        # 1 file that contains all 50 weeks of PULSE data w/ subsetted variables


# Housekeeping ------------------------------------------------------------
library(tidyverse)
library(assertthat)
library(vroom)

relevant_cols <-  c("TBIRTH_YEAR", "EGENDER", "RHISPANIC","RRACE","EEDUC","MS",
                    "THHLD_NUMPER","THHLD_NUMKID","THHLD_NUMADLT",
                    "ANYWORK","KINDWORK","TW_START",
                    "EXPNS_DIF","CURFOODSUF","CHILDFOOD","FOODSUFRSN1",
                    "FOODSUFRSN2","FOODSUFRSN3","FOODSUFRSN4","FOODSUFRSN5",
                    "FREEFOOD", "SNAP_YN", "TSPNDFOOD", "TSPNDPRPD", "FOODCONF",
                    "ENROLL1", "ENROLL2", "ENROLL3", "TEACH1", "TEACH2","TEACH3",
                    "TEACH4","TEACH5","INCOME","EST_MSA","WEEK","PWEIGHT",
                    "HWEIGHT","KIDS_LT5Y","KIDS_5_11Y",
                    "KIDS_12_17Y", "SCRAM", "EGENID_BIRTH", 
                    "NOSCHLFDHLP")


# Creating master data ----------------------------------------------------

dirs <- list.dirs("data/raw")[-1] #deleting root directory fp  

pulse_files_main <- lapply(dirs, function(dir){
    files <- list.files(dir)
    
    folder_number <- str_pad(parse_number(str_split(dir, "/", simplify = TRUE)[,8]), width = 2, side = "left", pad = "0")
    year <- parse_number(list.files(dir)[1])
    main_file <- read_csv(file = paste0(dir, "/pulse", year, "_puf_", folder_number, ".csv"), 
                          col_select = tidyselect::any_of(relevant_cols))

    
    return(
        main_file
    )
})
bind_rows(pulse_files_main) %>% 
    write_csv(pulse_files_all, "data/processed/HPS_all.csv")



