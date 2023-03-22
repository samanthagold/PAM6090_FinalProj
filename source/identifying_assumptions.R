# Purpose -----------------------------------------------------------------
    # The purpose of this script is to validate our identifying 
    # assumption for the event study design that we are using to
    # identify the causal effects. 


# Housekeeping ------------------------------------------------------------
outdir <- "data/processed/"
final_sample <- read_csv(paste0(outdir, "final_sample_treatment.csv"), 
                        show_col_types = FALSE, 
                        progress = FALSE)

# Data Prep and Plot -------------------------------------------------------
plot <- final_sample %>% 
    mutate(foodsecure = case_when(curfoodsuf == 1 ~ 1, 
                                  curfoodsuf == 2 ~ 0, 
                                  TRUE ~ NA_real_), 
           week2 = week - 34, 
           week3 = week - 33) %>% 
    filter(!is.na(foodsecure), !is.na(treat)) %>%
    group_by(treat, week3) %>% 
    summarize(mean_foodsecure = mean(foodsecure)) %>% 
    ggplot(aes(x = factor(week3), y = mean_foodsecure* 100, col = factor(treat))) + 
    geom_point(size = 3) + 
    geom_line(aes(aes.inherit = TRUE), lwd = 1.25, size = 2) + 
    geom_line(aes(group = factor(treat))) + 
    geom_vline(xintercept = "0", linetype = "dotted") + 
    xlab("Weeks Since Event") + 
    ylab("Percentage") + 
    theme(legend.position = "top")  + 
    theme_classic() + 
    scale_colour_manual(values=c( "grey", "black"), 
                        labels =c("All Kids < Pre-K Age (Treat = 1)", 
                                  "All Kids > Pre-K Age (Treat = 0)")) +
    labs(title ="Household Food Security by Treatment Group", 
         caption = "Source: Census Household Pulse Survey") + 
    theme(axis.title.x = element_text(size = 20), 
          axis.text.x = element_text(size=15), 
          axis.title.y = element_text(size=20), 
          axis.text.y = element_text(size=18), 
          plot.title = element_text(size=18, hjust = 0.5), 
          plot.caption = element_text(size=14),
          plot.subtitle = element_text(size = 16), 
          legend.title= element_blank(),
          legend.text = element_text(size=12), 
          legend.position = "top")
ggsave(filename = "tables/identifying_assumptions.png", plot = plot)
