source("01-deps.R")

fluxes_data <- readRDS(fluxes_data_file)

good_quality_filter <- fluxes_data[, quality_flag %in% c("OK")]

# ------------------------------------------------------------------------------
# Cumulative carbon fluxes

# Convert cumulative flux to gr/m-2
# mole * 44.01 = gr
# Each flux point is the average for 30 minutes
# flux * 30 * 60 * 44.01 * 1e-6
umol_per_sec_to_grC <-  30 * 60 * 12.001 * 1e-6
fluxes_data[, co2_err_cs := 0]
fluxes_data[ good_quality_filter == TRUE, 
            co2_err_cs := sqrt(cumsum(rand_err_co2_flux_ec^2))*umol_per_sec_to_grC]
fluxes_data[good_quality_filter == TRUE, co2_flux_ec_cs := cumsum(co2_flux_ec)*umol_per_sec_to_grC]
fluxes_data[good_quality_filter == TRUE, co2_flux_tea_cs := cumsum(co2_flux_tea)*umol_per_sec_to_grC]
#
ts_start        <- ymd_hms("2020-06-18 00:00:00")
ts_end          <- ymd_hms("2020-07-29 02:00:00")
minor_date_brks <- seq(ts_start, ymd_hms("2020-07-31 00:00:00"), "7 days")

cumulative_fluxes <- 
    ggplot(fluxes_data[good_quality_filter][time > ts_start & time < ts_end])  + 
    geom_vline(xintercept = minor_date_brks, col = "gray90", size = .5, lty = 2) +
    geom_ribbon(aes(x = time, ymin = co2_flux_ec_cs - 2*co2_err_cs, 
                    ymax = co2_flux_ec_cs + 2*co2_err_cs), alpha = .3) +
    geom_ribbon(aes(x = time, ymin = co2_flux_tea_cs - 2*co2_err_cs, 
                    ymax = co2_flux_tea_cs + 2*co2_err_cs), alpha = .3) +
    geom_line(aes(time, co2_flux_ec_cs, col = "EC")) + 
    geom_line(aes(time, co2_flux_tea_cs, col = "STEA")) +
    labs (x = "Date",
          y = expression (paste(Cumulative~CO[2], " flux (", gr~C~m^-2, ")")))  +
          scale_color_manual("Method ", values = method_pallete) +
          theme_copernicus() +
          legend_below() +
    no_grid() 

psave("Fig09.pdf", p = cumulative_fluxes,
      width = 8.3*0.6, height = 8.3*0.4,scale = 2.4,
      output_dir = plot_output_dir)
