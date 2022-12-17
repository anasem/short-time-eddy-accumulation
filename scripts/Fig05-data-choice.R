source("01-deps.R")

theme_set(theme_copernicus())
plot_output_dir <- path.expand("../figures")


# Load required data
gas_analyzer_data       <- readRDS(gas_analyzer_file)
events_summaries_data   <- readRDS(events_summaries_file)
gas_analyzer_stats_data <- readRDS(gas_analyzer_stats_file)

plot_ts_start <- gas_analyzer_data[, first(time)]
plot_ts_end  <- gas_analyzer_data [, last(time)]

y_min <- min(gas_analyzer_data[["CO2_dry"]], na.rm = TRUE)
y_max <- max(gas_analyzer_data[["CO2_dry"]], na.rm = TRUE)

expand_y <- (y_max - y_min)*.15
y_min <- y_min - expand_y
y_max <- y_max + expand_y*.5


data_choice_and_fitting <- 
  ggplot(data = gas_analyzer_data) + 
    aes(x = time, y = CO2_dry) +
    # Buffer rectangles in bg
    geom_rect(data = events_summaries_data, 
              aes(xmin = start_time, ymin = y_min, xmax = end_time, 
                  ymax = y_max, fill = is_updraft), inherit.aes = FALSE, 
              alpha = .5, show.legend = TRUE) +
    # Buffer borders dashed
    geom_vline(data = events_summaries_data, 
           aes(xintercept = start_time), linetype = 2,  
           size = .3, alpha = .3, show.legend = FALSE)  +
    # deadband points
    geom_point(data = gas_analyzer_data[f_is_deadband == TRUE], size = 1, 
               show.legend = FALSE, col = main_palette[4],
               alpha = .5,  aes(shape = "TRUE")) +
    # measurement points
    geom_point(data = gas_analyzer_data[f_is_deadband == FALSE],
               size = 1, show.legend = TRUE, 
               aes(color = is_updraft, 
                   fill = is_updraft,
                   shape = f_is_deadband)) +
    # measurement line
    geom_line(aes(color = NULL), alpha = .1, size = .5, show.legend = FALSE)  +
    # chosen point
    geom_point(data = gas_analyzer_stats_data, 
               aes(x = time + duration/1.5, y = CO2_dry, shape = "ChosenValue"), 
               color = "black", size = 2, 
               show.legend= FALSE) +
    # Scaling legened
    scale_shape_manual("", values = c("TRUE" = 1, "FALSE" = 16,  "ChosenValue" = 3), 
                       labels = c("TRUE" = "Flushing", "FALSE" = "included", 
                                  "ChosenValue" = "Fitted value"), 
                       guide = guide_legend(override.aes = list(fill = NA, size = 2)))  +
    scale_color_manual(name = "", 
                       values = sampling_channel_palett, 
                       label = c("Updraft", "Downdraft")) +
    scale_fill_manual(name = "", values = sampling_channel_alt_palette, 
                      label = c("Updraft", "Downdraft")) + 
    scale_x_datetime(limits = c(plot_ts_start, plot_ts_end), 
                     minor_breaks = NULL, expand = c(0,0)) +
    scale_y_continuous(expand = c(-.06,0)) + 
    labs(x = "Time",
         y = expression(paste(CO[2], " - dry (", mu, mol~mol^-1, ")")))  +
    theme_copernicus() +
        theme(plot.margin=grid::unit(c(1,7,1,1), "mm")) +
                theme(legend.margin = margin(1,1,1,1),
                      legend.box.margin = margin(1,1,1,1),
                      legend.title = element_text(size = 10, face = "bold",
                                                  margin = margin(0,5,0,0)),
                      legend.text= element_text(size = 10, 
                                                margin = margin(0,7,0,0)),
                      legend.justification = c(1, 0),
                      legend.spacing.x = unit(1,'mm'),
                      legend.key.size = unit(4, "mm"),
                      legend.background = 
                          element_rect(fill = alpha("white", .8))) +
         no_grid()

# save output
psave("Fig05.pdf", 
      p = data_choice_and_fitting, 
      height = 3.7, width = 8.3,
      output_dir = plot_output_dir)

