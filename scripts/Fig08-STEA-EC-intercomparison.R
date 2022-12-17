source("01-deps.R")

fluxes_data <- readRDS(fluxes_data_file)

good_quality_filter <- fluxes_data[, quality_flag %in% c("OK")]

ec_tea_lmodel2 <- 
    lmodel2(co2_flux_tea ~ co2_flux_ec,
                        data = fluxes_data[good_quality_filter])

fluxes_data <- fluxes_data[!duplicated(time)]

# Scatter plot with all data points --------------------------------------------
co2_flux_scatter <- 
    ggplot(fluxes_data[good_quality_filter])  + 
        aes(co2_flux_ec, co2_flux_tea, col = flag) + 
        geom_point(size = 1.8, alpha = .6, col = main_palette[5], 
                   shape = 16, stroke = 0) +
        geom_abline(slope = 1, alpha = .7, lty = 2, col = mp(1)) +
        geom_model_abline(ec_tea_lmodel2, color = mp(7), 
                          lwd = .9, alpha = .7) +
        geom_model_equation(ec_tea_lmodel2, -10, -45, size = 2.5, slope.digits = 3)  + 
        theme_copernicus() + 
        labs (x= expression (paste(EC~CO[2], " flux (", mu,mol~m^-2,~s^-1, ")")),
              y = expression (paste(TEA~CO[2], " flux (", mu,mol~m^-2,~s^-1, ")")))  +
        no_grid()

# Time series plot -------------------------------------------------------------
names(method_pallete) <- c("STEA", "EC")
ts_start <- ymd_hms("2020-06-18 00:00:00")
ts_end   <- ymd_hms("2020-06-27 00:00:00")
ts_end - ts_start
#
fluxes_wide_filtered <- copy(fluxes_data)
fluxes_wide_filtered[good_quality_filter == FALSE, co2_flux_ec := NA]
fluxes_wide_filtered[good_quality_filter == FALSE, co2_flux_tea := NA]
#
co2_ts_plot <- 
    ggplot(fluxes_wide_filtered[time > ts_start & time < ts_end]) + 
        aes(x = time) + 
        geom_line(data = fluxes_data[time > ts_start & time < ts_end], 
                  aes(y = co2_flux_ec, color = "EC"), alpha = .5) +
        geom_line(data = fluxes_data[time > ts_start & time < ts_end], 
                  aes(y = co2_flux_tea, color = "STEA"), alpha = .5) +
        geom_hline(yintercept = 0, color = "black", size = .3, alpha =.5, linetype= 3) + 
        geom_point(aes(y = co2_flux_ec, color = "EC") , size = 1) + 
        geom_line(aes(y = co2_flux_ec, color = "EC"), size = 1) +
        geom_point(aes(y = co2_flux_tea, color = "STEA") , size = 1) + 
        geom_line(aes(y = co2_flux_tea, color = "STEA"), size = 1) +
        scale_color_manual("Method ", values = method_pallete) +
        scale_x_datetime(date_minor_breaks= "1 day", expand = c(0,0)) + 
        scale_y_continuous(expand = expansion(mult = c(.1,.01)))  + 
        theme_copernicus() +
        labs(x = "Date",
             y = expression(paste(CO[2], " flux (", mu, mol, ~m^-2,~s^-1, ")"))) +
        no_grid()

# Diurnal cycle plot -----------------------------------------------------------
co2_diurnal_cycle_plot <- 
    ggplot(fluxes_data[good_quality_filter]) + 
        aes(x = hour(time) + minute(time)/60) +
        # Bands
        stat_summary(mapping = , aes(y = co2_flux_tea, color = "STEA", 
                                     fill = "STEA"),
                 geom="ribbon", fun.data=mean_cl_boot, 
                 fun.args=list(conf.int=0.95), 
                 alpha=.1, 
                 size = .2,
                 linetype = 3, show.legend = FALSE)  +
        # Mean line
        stat_summary(mapping = aes(y = co2_flux_tea, 
                               color = "STEA"), 
                 fun = mean, geom = "line", 
                 fun.args = list(na.rm = TRUE), size = 1, alpha = .9)  +
        # Bands EC
        stat_summary(mapping = aes(y = co2_flux_ec, color = "EC", 
                               fill = "EC"),
                 geom="ribbon", fun.data=mean_cl_boot, 
                 fun.args=list(conf.int=0.95), 
                 size = .2,
                 alpha=.1, 
                 linetype = 3, show.legend = FALSE)  +
        # Mean line EC
        stat_summary(mapping = aes(y = co2_flux_ec, 
                               color = "EC"), 
                 fun = mean, geom = "line", 
                 fun.args = list(na.rm = TRUE), size = 1, alpha = .9) +
        labs(x = "Hour",
            y = expression(paste(CO[2], " flux (", mu, mol, ~m^-2,~s^-1, ")"))) +
        theme_copernicus() +
        scale_fill_manual("Method", values = method_pallete) +
        scale_color_manual("Method", values = method_pallete)  +
        scale_x_continuous(expand = c(0,0), minor_breaks = NULL) +
        geom_hline(yintercept = 0, color = "black", size = .3, alpha =.5, linetype= 3) + 
        no_grid()

flux_comparisons_combined <- 
     (co2_ts_plot + theme(plot.margin = margin(30,0,40,0))) / 
         ((co2_diurnal_cycle_plot  +   
           guides (color = "none", fill = "none")) +
          co2_flux_scatter + plot_layout(widths = c(1.3,1)))  +
        plot_annotation(tag_levels = "a", tag_suffix = ")", 
                    theme = theme(plot.margin = margin(15,0,0,0))) +
            plot_layout(guides = "collect") & 
            theme(plot.tag.position = c(.1,1.15)) +
            legend_below()
            
psave("Fig08.pdf", 
      p = flux_comparisons_combined,
      width = 8.3, height = 8.3, 
      output_dir = plot_output_dir)
