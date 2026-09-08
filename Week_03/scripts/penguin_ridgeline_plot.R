### Homework: Penguin plotting assignment ################
### Created by: yang ######################################
### Updated on: 2026-09-08 #################################
### Purpose: Explore whether flipper length differs by sex ##
### within each Palmer Penguin species, using a ridgeline ###
### (density) plot -- NOT a scatter plot, and not the same ##
### bill depth x bill length plot we made together in class #
###############################################################


#### Load Libraries ###########################################
library(tidyverse)   # data wrangling + ggplot2
library(palmerpenguins)  # penguins data
library(ggridges)    # geom_density_ridges() for ridgeline plots
library(here)         # reproducible, machine-independent file paths


#### Load data #################################################
# The data is built into the palmerpenguins package as "penguins"
# Look at the raw data first -- always look at your data before plotting
glimpse(penguins)


#### Wrangle data ###############################################
# Keep raw data raw: build a new filtered object rather than
# overwriting `penguins`. Drop the few rows missing sex and/or
# flipper length so they don't get silently excluded later without
# us noticing (11 penguins have unknown sex; 2 are missing flipper
# length -- both checked with sum(is.na(...)) before writing this).
penguins_clean <- penguins %>%
  filter(!is.na(sex), !is.na(flipper_length_mm))


#### Make plot ###################################################
# Research question: does flipper length differ between male and
# female penguins, and is that pattern consistent across species?
#
# Ridgeline (density) plot: one ridge per sex, faceted by species,
# so we can compare the full distribution shape -- not just the
# mean -- of flipper length between males and females in each
# species. This is intentionally NOT a scatter plot, and shows a
# different question than our in-class bill depth x bill length
# scatterplot.
flipper_ridge_plot <- ggplot(data = penguins_clean,
                              mapping = aes(x = flipper_length_mm,
                                            y = sex,
                                            fill = sex)) +
  geom_density_ridges(alpha = 0.7,
                       scale = 1.3,
                       color = "white",
                       show.legend = FALSE) +
  facet_wrap(~ species, ncol = 1) +
  # Colorblind-safe palette (Okabe-Ito), consistent with responsible
  # plotting practices covered in lecture
  scale_fill_manual(values = c("female" = "#D55E00", "male" = "#0072B2")) +
  labs(
    x = "Flipper length (mm)",
    y = NULL,
    title = "Male penguins have longer flippers\nthan females in every species",
    subtitle = "But species differences are much larger than sex differences",
    caption = "Data: Gorman, Williams & Fraser (2014) via {palmerpenguins}"
  ) +
  theme_ridges(font_size = 13, grid = FALSE) +
  theme(
    strip.text = element_text(face = "bold", size = 13),
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 12),
    plot.caption = element_text(size = 9, color = "grey40")
  )

# Print to check it in the Plots pane before saving
flipper_ridge_plot


#### Save plot ####################################################
# here() builds a path from the project root, so this works no
# matter whose computer / working directory runs the script
ggsave(
  here("Week_03", "output", "penguin_flipper_ridgeline.png"),
  plot = flipper_ridge_plot,
  width = 7,
  height = 6,
  dpi = 300
)
