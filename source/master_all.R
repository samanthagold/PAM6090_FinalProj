
# Purpose -----------------------------------------------------------------
    # This is the master script for our final project. This runs our entire 
    # analysis from start (compiling our data) to finish (running our main 
    # specification. 


# Housekeeping ------------------------------------------------------------
library(tidyverse)
library(RStata)


# Script Inputs -----------------------------------------------------------
    # EDIT THE FOLLOWING TO RUN OUR CODE LOCALLY: 
        # stata_fp: points R to Stata app. If on a Mac, the below 
        #           should work. If on a non-Mac, follow setup 
        #           instructions here: https://github.com/lbraglia/RStata
        # stata_version: what version of Stata you are running 

# stata_fp <- "" 
# stata_version <- 
# Connecting to Stata so we can run Stata do files within R 
stata_fp <- "/Applications/Stata/StataSE.app/Contents/MacOS/stata-se" 
stata_version <- 15
options("RStata.StataPath" = stata_fp)
options("RStata.StataVersion" = stata_version)

# Root Directory Filepath 
root_fp            <- "/Users/sammygold/Desktop/PAM6090_PROJ/" # This is where you saved the .zip file 
setwd(root_fp)
sink("PAM6090_Project_Group1.txt", split = TRUE)


# Raw Data Construction -------------------------------------------------------
# NOTE: The output from this script is saved in data/processed/HPS_all.csv. To 
# save on run time and storage, we won't run this script but are including it 
# for completion. 

# source(paste0(root_fp, "source/sample_construction.R"))


# Sample Restrictions -----------------------------------------------------
# NOTE: This script implements our sample restrictions. To save on run time, we
# have provided the output to this script in data/processed/pulse_final_sample.dta" 
# but are including it here for completion/transparency. 

# stata ("
#        cd /Users/sammygold/Desktop/PAM6090_PROJ/
#        do source/sample_restrictions.do
#        "
# )


# Running Main Analysis ---------------------------------------------------
stata("
      cd /Users/sammygold/Desktop/PAM6090_PROJ/
      do source/PAM6090_Proj_Regressions_SG.do
      
      
      ")


# Generating Summary Statistics Table -------------------------------------
source("source/descriptive_table.R", 
       echo = TRUE, 
       max.deparse.length = 1e3)


# Generating Identifying Assumption Plot ----------------------------------
source("source/identifying_assumptions.R", 
       echo = TRUE, 
       max.deparse.length = 1e3)


# Generating Event Study Plots --------------------------------------------
source("source/prep_eventstudy_plot_dat.R", 
       echo = TRUE, 
       max.deparse.length = 1e3)
stata("  
      cd /Users/sammygold/Desktop/PAM6090_PROJ/
      do source/PAM6090_Proj_EventStudyPlots.do

      "
)

# Extension ---------------------------------------------------------------
#source(paste0(root_fp, ""))

sink()






