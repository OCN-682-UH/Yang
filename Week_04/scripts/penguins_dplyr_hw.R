### Homework: dplyr practice with penguin data ################
### Created by: yang ############################################
### Updated on: 2026-09-15 ######################################
### Purpose: (1) Summarise body mass by species/island/sex with ##
###          no NAs. (2) Filter to female penguins, log-transform#
###          body mass, and visualize it with best practices. ####
###################################################################


#### Load Libraries ###############################################
library(tidyverse)       # dplyr verbs + ggplot2
library(palmerpenguins)  # penguins data
library(here)            # reproducible, machine-independent file paths


#### Load data ######################################################
# The data is built into the palmerpenguins package as "penguins"
glimpse(penguins)


#### Part 1: mean and variance of body mass by species/island/sex ###
# drop_na() removes any row missing species, island, sex, or body_mass_g
# (rather than just na.rm = TRUE inside mean()/var()) so that we don't
# end up with a spurious "NA" group in the summary table.
body_mass_summary <- penguins |>
  drop_na(species, island, sex, body_mass_g) |>
  group_by(species, island, sex) |>
  summarise(
    mean_body_mass_g = mean(body_mass_g),
    var_body_mass_g  = var(body_mass_g),
    n                = n(),
    .groups = "drop"
  )

# Look at the result
body_mass_summary


#### Part 2: female penguins, log body mass, and a plot #############
# Filter out male penguins (sex != "male" also drops the few NA-sex
# rows, since a comparison against NA is itself NA and filter() only
# keeps rows where the condition is TRUE).
penguins_female_log <- penguins |>
  filter(sex != "male") |>
  mutate(log_mass = log(body_mass_g)) |>
  select(species, island, sex, log_mass)

glimpse(penguins_female_log)

# Research question: how does (log) body mass differ among female
# penguins of the three species, and how much does that vary by
# island? A violin shows the full distribution shape (not just a
# median/IQR box), and jittered points on top show the real
# observations underneath the distribution -- following the
# "show me the data, don't just show summary stats" principle from
# lecture. Island is mapped to point *shape* rather than a second
# color scale, so the figure only needs one legend and stays easy
# to read.
female_logmass_plot <- ggplot(data = penguins_female_log,
                               mapping = aes(x = species, y = log_mass)) +
  geom_violin(aes(fill = species), alpha = 0.6, show.legend = FALSE) +
  geom_jitter(aes(shape = island),
              width = 0.08, height = 0,
              alpha = 0.6, size = 2, color = "black") +
  scale_fill_viridis_d() +               # colorblind-safe palette
  labs(
    x = "Species",
    y = "log(Body mass, g)",
    shape = "Island",
    title = "Female penguin body mass varies\nby species and island",
    subtitle = "Gentoo females are heaviest and only found on Biscoe;\nAdelie females are found on all three islands",
    caption = "Data: Gorman, Williams & Fraser (2014) via {palmerpenguins}"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    legend.position = "top",
    plot.title = element_text(face = "bold", size = 15),
    plot.subtitle = element_text(size = 11)
  )

# Print to check it before saving
female_logmass_plot


#### Save the plot to the output folder ###############################
ggsave(
  here("Week_04", "output", "female_penguin_logmass_violin.png"),
  plot = female_logmass_plot,
  width = 7.5, height = 5.5, dpi = 300
)
