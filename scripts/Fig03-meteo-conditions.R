source("01-deps.R")

meteo_lg   <- readRDS(meteo_lg_file)
meteo_ep   <- readRDS(meteo_ep_file)
percip_dwd <- readRDS(meteo_dwd_file)

start_time              <- ymd_hms("2020-06-18 00:00:00")
end_time                <- ymd_hms("2020-07-31 00:00:00")
custom_date_brks        <- seq(start_time, end_time, "1 days")
minor_date_brks         <- seq(start_time, end_time, "7 days")
label_at                <- seq(1, length(custom_date_brks), 6)
custom_labels           <- rep("", length(custom_date_brks))
custom_labels[label_at] <- format(custom_date_brks[label_at], "%d %b")

weekly_x_breaks <- function() {
      scale_x_datetime(breaks =  custom_date_brks, 
                       labels = custom_labels, expand = c(0,0))
}

# Soil humidity
soil_water_content <- 
 ggplot(meteo_lg) +
    geom_vline(xintercept = minor_date_brks, col = "gray90", size = .5, lty = 2) +
    geom_line(aes(time, SWC_1_1_1, col = "1"))  +
    geom_line(aes(time, SWC_2_1_1, col = "2"), alpha = .6) +
    geom_line(aes(time, SWC_3_1_1, col = "3")) +
    scale_color_manual("rep.", values = mp(2,5,6)) +
    theme_copernicus() +
    theme(legend.position = c(.99, 0.82)) +
    labs(x = "", y = expression(paste("Soil water (",cm^3~cm^-3, ")"))) +
    no_grid() +
    weekly_x_breaks()

eddypro_air_temp <-
  ggplot(meteo_ep) + 
    geom_vline(xintercept = minor_date_brks, col = "gray90", size = .5, lty = 2) +
      aes(time, air_temperature - 273.15) + 
      geom_line(col = mp(5)) + 
      theme_copernicus() + 
      labs( y = "Air T (°C)", x= "") +
      weekly_x_breaks() +
      no_grid() 

eddypro_RH <-
  ggplot(meteo_ep) + 
    geom_vline(xintercept = minor_date_brks, col = "gray90", size = .5, lty = 2) +
    aes(time, RH) + 
    geom_line(col = mp(5)) + 
    theme_copernicus() +
    labs( y = "RH (%)", x = "") +
    weekly_x_breaks() +
    no_grid() 

eddypro_windspeed <- 
  ggplot(meteo_ep) + 
    geom_vline(xintercept = minor_date_brks, col = "gray90", size = .5, lty = 2) +
    aes(time, wind_speed) + 
    geom_line(col = mp(5)) + 
    theme_copernicus() +
    labs( y = expression(paste("U (", m, " " , s^-1, ")", sep="")),
         x = "") +
    weekly_x_breaks() +
    no_grid() 


eddypro_wind_dir <-
  ggplot(meteo_ep) + 
    geom_vline(xintercept = minor_date_brks, col = "gray90", size = .5, lty = 2) +
    aes(time, wind_dir) + 
    geom_point(col = mp(5), size = .3) + 
    theme_copernicus() +
    ylim(c(0,360)) +
    labs( y = "Wind dir. (°)", x = "")  +
    weekly_x_breaks() +
    no_grid() 

# Sensible heat flux
eddypro_heatfluxes <- 
  ggplot(meteo_ep) + 
    geom_vline(xintercept = minor_date_brks, col = "gray90", size = .5, lty = 2) +
    aes(time, H) + 
    geom_line(aes(color = "H")) +
    ylim(c(-40, 400)) + 
    geom_hline(yintercept =  0, alpha = .1) +
    geom_line(aes(y = LE, color = "LE")) + # Latent heat flux
    labs( y = expression(paste("Heat flux (",   W, " " , m^-2,")", sep="")),
         x = "") +
    theme_copernicus() + 
    no_grid() +
    scale_color_manual("Heat flux ", values = main_palette[c(2,6)]) +
    weekly_x_breaks() +
    theme(legend.position = c(.99, 0.82)) +
    no_grid() 

precipitation <- 
    ggplot(percip_dwd) + 
    geom_vline(xintercept = minor_date_brks, col = "gray90", size = .5, lty = 2) +
    geom_line(aes(time, rain_daily_cs))  +
    theme_copernicus () + 
    no_grid() +
    weekly_x_breaks() +
    labs(x = "", y = "Rain (mm)")

meteo_combined <- 
    (eddypro_air_temp) /
    eddypro_RH / soil_water_content /
    precipitation/
    eddypro_windspeed / eddypro_wind_dir /
    (eddypro_heatfluxes) &
    theme(panel.grid.minor.x = element_blank(),
          panel.grid.major.x = element_blank())


ggsave(file.path(plot_output_dir, "Fig03.pdf"), meteo_combined, 
       device = cairo_pdf, units = "cm",
       width = 8.3, height = 15, scale = 2)



