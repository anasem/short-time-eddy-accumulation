source("01-deps.R")

BV_simulation_fluxes <- readRDS(BV_simulation_file)
good_quality_filter  <- BV_simulation_fluxes[, abs(r_Ts_w) > 0.25]

# Slopes of filtered flux at each tau
fluxes_lm <- 
    BV_simulation_fluxes[good_quality_filter,
    {lm_Ts = lm(H_STEA ~ H - 1); 
           lm_C = lm(C_flux_STEA ~ C_flux - 1); 
           list(Ts_slope = 1/coef(lm_Ts)[1], 
                C_slope = 1/coef(lm_C)[1],
                N = .N,
                Ts_Slope_SE = sqrt(diag(vcov(lm_Ts)))[1],
                C_Slope_SE = sqrt(diag(vcov(lm_C)))[1])}, 
        by = tau_BV]

regression_plot <- 
    ggplot(BV_simulation_fluxes[good_quality_filter][tau_BV == 11]) + 
        aes(H, H_STEA) + 
        geom_smooth(formula = y ~ x -1, method = 'lm', col = mp(2), se = FALSE) +
        geom_abline(slope = 1, lty = 2) +
        geom_point(col = mp(5)) + theme_copernicus()  +
        no_grid() +
        labs(x = expression(paste("H [", W~m^-2, "]")),
             y = expression(paste("H_BV [", W~m^-2, "]")))

flux_attenuation_plot  <- 
    ggplot(fluxes_lm) + 
        aes(tau_BV) +  
        geom_ribbon(aes(ymin = C_slope - C_Slope_SE, 
                        ymax = C_slope + C_Slope_SE , fill = "C slope"),
                        show.legend = FALSE,
                    alpha = .2)  +
        geom_ribbon(aes(ymin = Ts_slope - Ts_Slope_SE,
                        ymax = Ts_slope + Ts_Slope_SE , fill = "Ts slope"), 
                    alpha = .2,
                    show.legend = FALSE) +
        geom_line(aes(y = C_slope, col = "C slope"), lwd = 1)  +
        geom_line(aes(y = Ts_slope, col = "Ts slope"), lwd = 1)  + 
        theme_copernicus() + 
        labs(x = expression(paste(BV~tau, " [minutes]")),
             y = "Correction factor") +
        scale_color_manual("Scalar", values = mp(2,6), labels = c("CO2", "Ts"))+
        scale_fill_manual("Scalar", values = mp(2,6), labels = c("CO2", "Ts")) +
        no_grid()


empirical_bv_correction_plots <- 
    regression_plot + flux_attenuation_plot + 
        plot_annotation(tag_level = "a", tag_suffix = ")")

psave("Fig10.pdf",
      p = empirical_bv_correction_plots,
      height = 3.8, width = 8.3,
      output_dir = plot_output_dir)

