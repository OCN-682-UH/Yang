# Yang
# OCN 682 / MBIO 612 Repository

This repository contains my coursework for **OCN 682 / MBIO 612: Scripting and Reproducible Research** at the University of Hawaiʻi at Mānoa.

## About This Repository

The repository includes scripts, data, and other materials created throughout the course.

Current contents include:

- **Week 2** – My first script and the associated data
- **Week 3** – Penguin plotting practice: a ridgeline (density) plot of flipper length by sex and species, built with ggplot2/ggridges
- Additional weekly assignments and course materials will be added as the semester progresses
- **Week 4** – dplyr and tidyr practice: penguin body mass summaries and a violin plot (dplyr), plus cleaning, separating, pivoting, and summarizing the Maunalua Bay groundwater chemistry data with a log-log scatter plot (tidyr)
- **Week 5** – Joins and dates with lubridate: rounding and joining a conductivity logger to a depth logger by exact timestamp with inner_join(), averaging by minute, and a patchwork time-series plot of depth, temperature, and salinity
- **Week 6** –  Quarto report - a rendered Quarto HTML document revisiting the palmerpenguins dataset, with a styled summary table (mean bill and flipper length by species and sex) and a publication-quality scatter plot (bill length vs. flipper length, colored by species with per-species trend lines) (scripts/, output/). Live published version: https://01a0ef8d-7fe0-f035-c5f5-7d3ac01f9074.share.connect.posit.cloud/
- **goodplot-badplot** – Good Plot / Bad Plot contest: a rendered Quarto document using the EuStockMarkets dataset (DAX, SMI, CAC, FTSE, 1991-1998) that builds a deliberately misleading plot (truncated axis, cherry-picked window, clashing colors, unsupported title) alongside an honest, normalized, colorblind-safe version of the same data, each with a written breakdown of every design choice (goodplot-badplot/data/, goodplot-badplot/scripts/, goodplot-badplot/output/). Live published version: https://01a0efcd-6f87-442a-5529-d253e2db03e1.share.connect.posit.cloud/
- **Week 7** – Mapping with Quarto - a geom_polygon() world map of the TidyTuesday Meteorite Landings dataset, cleaned of missing/placeholder coordinates and data-entry errors, colored by whether the fall was witnessed (Fell) vs. discovered later (Found) and sized by mass on a log scale, with a short interpretation of the detection-bias pattern this reveals (data/, scripts/, output/). Live published version: https://01a113ab-b293-9b34-6c4c-ae81e3f4359a.share.connect.posit.cloud/

The purpose of this repository is to practice organizing research projects, writing reproducible scripts, using Git and GitHub for version control, and documenting analyses clearly.

## About Me

My name is **Yang An**. I am a PhD student in Finance at the University of Hawaiʻi at Mānoa.

My academic interests include finance, data analysis, statistical modeling, and reproducible research. I have experience working with **R, Python, SQL, and Git/GitHub**, and I am taking this course to strengthen my scripting and reproducible research skills.

## Repository Structure

```text
.
├── Week 2/
│   ├── script
│   └── data
├── Week_03/
│   ├── scripts
│   └── output
├── Week_04/
│   ├── data
│   ├── scripts
│   └── output
├── Week_05/
│   ├── data
│   ├── scripts
│   └── output
└── Week_06/
    ├── scripts/
    │   └── quarto_penguins_report.qmd
    └── output/
        ├── quarto_penguins_report.html
        └── fig-scatter-1.png
└── goodplot-badplot/
    ├── data/
    │   └── eu_stock_markets_long.csv
    ├── scripts/
    │   └── goodplot_badplot.qmd
    └── output/
        ├── goodplot_badplot.html
        ├── fig-bad-1.png
        └── fig-good-1.png
└── Week_07/
    ├── data/
    │   └── meteorites.csv
    ├── scripts/
    │   └── meteorite_map.qmd
    └── output/
        ├── meteorite_map.html
        └── fig-meteorite-map-1.png
└── README.md