### Homework: joins & dates with a conductivity + depth logger ###
### Created by: yang #################################################
### Updated on: 2026-09-22 ############################################
### Purpose: join a conductivity/salinity logger to a co-located #####
### depth logger by exact timestamp, average the combined record #####
### by minute, and plot how depth, temperature, and salinity moved ###
### together over the ~4 hour deployment. ##############################
##########################################################################


#### Load Libraries #######################################################
library(tidyverse)   # dplyr + ggplot2 (lubridate is loaded as part of tidyverse)
library(here)         # reproducible, machine-independent file paths
library(patchwork)    # combine multiple ggplots into one figure


#### Read in the conductivity data, convert + round its date column ######
# CondData's "date" column is text in US format (M/D/YYYY H:MM:SS), so it
# needs mdy_hms() to become a real datetime. The logger's clock records
# every ~10 seconds but a couple of seconds off the depth logger's clock
# (e.g. 08:24:42 instead of 08:24:40), so round_date() to the nearest 10
# seconds puts it on the same timestamp grid as the depth data -- without
# this, inner_join() would find almost no exact matches.
CondData_rounded <- read_csv(here("Week_05", "data", "CondData.csv"),
                             show_col_types = FALSE) |>
  mutate(date = mdy_hms(date)) |>
  mutate(date = round_date(date, "10 seconds"))

glimpse(CondData_rounded)


#### Read in the depth data, convert its date column ######################
# DepthData's "date" column is already in ISO-ish format (YYYY-MM-DD
# HH:MM:SS), already on exact 10-second marks, so it just needs ymd_hms()
# to become a real datetime -- no rounding necessary.
DepthData_clean <- read_csv(here("Week_05", "data", "DepthData.csv"),
                            show_col_types = FALSE) |>
  mutate(date = ymd_hms(date))

glimpse(DepthData_clean)


#### Join, then average by minute (one pipe, no extra intermediate objects) ##
# inner_join() keeps ONLY timestamps present in both loggers (exact matches
# after rounding) -- this is intentional: we only want moments where we
# have both a depth AND a water-chemistry reading, and it also drops the
# ~45 minutes at the start where the conductivity logger was running before
# the depth logger was deployed.
# floor_date() then buckets every matched timestamp into the minute it
# falls in, and group_by()+summarise() averages Depth, Temperature, and
# Salinity within each minute -- "date" below IS the per-minute time bucket
# (the averaged/binned date), so it satisfies the "average by minute" for
# all four fields (date, depth, temperature, salinity) at once.
minute_avg <- inner_join(CondData_rounded, DepthData_clean, by = "date") |>
  mutate(date = floor_date(date, "minute")) |>
  group_by(date) |>
  summarise(
    mean_depth       = mean(Depth),
    mean_temp        = mean(Temperature),
    mean_salinity    = mean(Salinity),
    n_readings       = n(),
    .groups = "drop"
  )

glimpse(minute_avg)

# Check for partial minutes: at 1 reading per 10 seconds, a full minute
# should have 6 readings. The deployment window starts and ends mid-minute,
# so the very first and last minute only have 3-4 readings -- less reliable
# averages than every other (complete) minute. Drop just those two edge
# minutes for plotting, but keep them in the exported csv (with n_readings)
# so nothing is silently hidden from the data.
# Note: depth genuinely reads near 0 m for the first ~2 minutes even after
# this filter -- that's the logger settling in as it was deployed, not a
# wrangling error (confirmed it's consistent across both the partial AND
# the following complete minute).
table(minute_avg$n_readings)
minute_avg_complete <- minute_avg |>
  filter(n_readings == 6)


#### Make a plot using the averaged data ###################################
# Three stacked time series (patchwork), sharing a time axis, so depth
# (the tide), temperature, and salinity can be compared minute-by-minute
# across the deployment without cramming three different units onto one
# y-axis.
depth_panel <- ggplot(minute_avg_complete, aes(x = date, y = mean_depth)) +
  geom_line(color = "#0072B2", linewidth = 0.8) +
  labs(y = "Depth (m)") +
  theme_minimal(base_size = 12) +
  theme(axis.title.x = element_blank(), axis.text.x = element_blank())

temp_panel <- ggplot(minute_avg_complete, aes(x = date, y = mean_temp)) +
  geom_line(color = "#D55E00", linewidth = 0.8) +
  labs(y = "Temperature (deg C)") +
  theme_minimal(base_size = 12) +
  theme(axis.title.x = element_blank(), axis.text.x = element_blank())

salinity_panel <- ggplot(minute_avg_complete, aes(x = date, y = mean_salinity)) +
  geom_line(color = "#009E73", linewidth = 0.8) +
  labs(x = "Time", y = "Salinity (PSU)") +
  theme_minimal(base_size = 12)

# Stack the three panels and add one shared title/caption with patchwork
combined_plot <- depth_panel / temp_panel / salinity_panel +
  plot_annotation(
    title = "Depth, temperature, and salinity over a single deployment",
    subtitle = "One-minute averages, 2021-01-15, matched by exact timestamp (inner join)",
    caption = "Conductivity logger (Serial 316) joined to a co-located depth logger"
  )

# Print to check it before saving
combined_plot


#### Save the plot to the output folder #####################################
ggsave(
  here("Week_05", "output", "depth_temp_salinity_timeseries.png"),
  plot = combined_plot,
  width = 8, height = 8, dpi = 300
)


#### Save the averaged data to the output folder ############################
write_csv(minute_avg,
          here("Week_05", "output", "minute_averaged_depth_temp_salinity.csv"))
