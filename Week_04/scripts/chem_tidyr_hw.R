### Homework: tidyr practice with Maunalua Bay chemistry data ###
### Created by: yang ###############################################
### Updated on: 2026-09-15 ##########################################
### Purpose: clean the groundwater-discharge chemistry data, tidy ###
### the Tide_time column, subset to one season, reshape to long #####
### format, export summary statistics, and visualize a relationship #
#######################################################################


#### Load Libraries #####################################################
library(tidyverse)   # dplyr + tidyr + ggplot2
library(here)         # reproducible, machine-independent file paths


#### Load data ############################################################
# Data and dictionary live in Week_04/data (see chem_data_dictionary.csv
# for variable descriptions and units)
ChemData <- read_csv(here("Week_04", "data", "chemicaldata_maunalua.csv"),
                     show_col_types = FALSE)
glimpse(ChemData)


#### Clean + tidy the data ##################################################
# 1. drop_na() removes any row with a missing value in ANY column (Zone/
#    Lat/Long are missing for 5 rows; several chemistry columns are missing
#    a handful of values too)
# 2. separate_wider_delim() splits the messy "Tide_time" column (e.g.
#    "Low_Day") into two clean columns, Tide ("Low"/"High") and Time
#    ("Day"/"Night"), so each column holds exactly one piece of information
#    (cols_remove = FALSE keeps the original column too, for reference)
# 3. filter() subsets the data to the SPRING season only -- this keeps the
#    tide/time/site comparisons below from being confounded by season
ChemData_clean <- ChemData |>
  drop_na() |>
  separate_wider_delim(cols        = Tide_time,
                        delim       = "_",
                        names       = c("Tide", "Time"),
                        cols_remove = FALSE) |>
  filter(Season == "SPRING")

glimpse(ChemData_clean)


#### Reshape to long format ##################################################
# Pivot all the biogeochemical measurement columns (Temp_in through
# percent_sgd) into a single Variable/Value pair. This makes it easy to
# group by Variable below and get summary stats for every chemical
# parameter at once, instead of repeating summarise() for each one.
ChemData_long <- ChemData_clean |>
  pivot_longer(cols      = Temp_in:percent_sgd,
               names_to  = "Variable",
               values_to = "Value")

glimpse(ChemData_long)


#### Summary statistics ######################################################
# Mean, SD, and sample size for every chemical variable, by site and tide
chem_summary_stats <- ChemData_long |>
  group_by(Variable, Site, Tide) |>
  summarise(
    mean_value = mean(Value),
    sd_value   = sd(Value),
    n          = n(),
    .groups = "drop"
  )

chem_summary_stats

# Export the summary table to the output folder
write_csv(chem_summary_stats,
          here("Week_04", "output", "chem_summary_stats.csv"))


#### Make a plot (not a boxplot) #############################################
# Research question: is submarine groundwater discharge (percent_sgd)
# associated with higher nitrate+nitrite (NN) concentrations? A scatter
# plot with a linear trend line shows the actual relationship between two
# continuous variables (not just group summaries). Both variables are
# heavily right-skewed (most sites have very little groundwater influence
# and low nitrate, a few have a lot of both), so BOTH axes are log-scaled:
# this keeps the pattern from being crushed into one corner of the plot,
# and keeps the fitted trend line from predicting impossible negative
# nitrate concentrations the way a linear-scale fit would. This is a
# "responsible plotting" choice covered in lecture, not just cosmetic.
sgd_nn_plot <- ggplot(data = ChemData_clean,
                       mapping = aes(x = percent_sgd, y = NN, color = Tide)) +
  geom_point(alpha = 0.7, size = 2) +
  geom_smooth(method = "lm", se = TRUE) +
  scale_x_log10() +
  scale_y_log10() +
  scale_color_manual(values = c("Low" = "#0072B2", "High" = "#D55E00")) +
  facet_wrap(~ Site) +
  labs(
    x = "Submarine groundwater discharge (%, log scale)",
    y = "Nitrate + nitrite (umol/L, log scale)",
    color = "Tide",
    title = "More groundwater discharge means more nitrate+nitrite",
    subtitle = "Spring season; relationship holds at both sites and both tide stages",
    caption = "Data: Silbiger et al. (2020) Proc. R. Soc. B, Maunalua Bay, Hawaii"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    legend.position = "top",
    plot.title = element_text(face = "bold", size = 15),
    plot.subtitle = element_text(size = 11),
    strip.text = element_text(face = "bold")
  )

# Print to check it before saving
sgd_nn_plot


#### Save the plot to the output folder ######################################
ggsave(
  here("Week_04", "output", "chem_sgd_vs_nitrate_scatter.png"),
  plot = sgd_nn_plot,
  width = 8, height = 5.5, dpi = 300
)
