# Source dependencies 
message("Sourcing dependencies")

# Libraries --------------------------------------------------------------------

required_packages <- c("ggplot2", "data.table", 
                       "lmodel2", "lubridate", 
                       "latex2exp", "patchwork")

not_installed <- required_packages[!(required_packages %in% rownames(installed.packages()))]

if (length(not_installed) > 0) {
    stop(paste("The following packages are not installed:", 
                  paste(not_installed, collapse=", ")))
} else { 
    library(ggplot2)
    library(data.table)
    library(lmodel2)
    library(lubridate)
    library(latex2exp)
    library(patchwork)
}



# Options ----------------------------------------------------------------------
project_dir     <- R.utils::getAbsolutePath("..")
data_dir        <- file.path(project_dir, "data")


plot_output_dir <- path.expand(file.path(project_dir, "figures"))

# External scripts -------------------------------------------------------------

source(file.path(project_dir, "scripts/02-theme.R"))
theme_set(theme_copernicus())

BV_sim_data_file        <- file.path(data_dir, 'rds/BV_frequency_response.rds')
meteo_ep_file           <- file.path(data_dir, 'rds/meteo_ep.rds')
meteo_dwd_file          <- file.path(data_dir, 'rds/meteo_dwd.rds')
meteo_lg_file           <- file.path(data_dir, 'rds/meteo_lg.rds')
gas_analyzer_file       <- file.path(data_dir, "rds/gas_analyzer_20M.rds")
events_summaries_file   <- file.path(data_dir, "rds/events_summary_20M.rds")
gas_analyzer_stats_file <- file.path(data_dir, "rds/gas_analyzer_stats_20M.rds")
high_freq_ec_30M_file   <- file.path(data_dir, 'rds/high_freq_ec_30M.rds')
water_calib_data_file   <- file.path(data_dir, "rds/water_calibration_data.rds")
fluxes_data_file        <- file.path(data_dir, "rds/stea_ec_fluxes.rds")
BV_simulation_file      <- file.path(data_dir, "rds/BV_simulation_fluxes.rds")

