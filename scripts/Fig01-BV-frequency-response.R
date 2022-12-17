source("01-deps.R")

BV_sim_data <- readRDS(BV_sim_data_file)

# Magnitude plot
mag_plot <- 
    ggplot(data = BV_sim_data) + 
        aes(freq, col = as.factor(q)) +
        geom_line(aes(y = magnitude), size = 1) +
        geom_vline(aes(xintercept = fc, col = as.factor(q)),
                   show.legend = FALSE, lty = 2)+
        geom_text(aes(x = 0.017, y = .5,
                      label = paste("tau==", "19"), col = '0.05'),
                  parse = TRUE,
                  check_overlap = TRUE, angle = -56) +
        geom_text(aes(x = 0.035, y = .5, col = '0.1', 
                      label = paste('tau==', "9")), 
                  parse = TRUE,
                  check_overlap = TRUE, angle = -56) +
        geom_text(aes(x = 0.087, y = .6, col = '0.3', 
                      label = paste('tau==', "3")), 
                  parse = TRUE,
                  check_overlap = TRUE, angle = -56) +
        labs (x = "Frequency (Hz)", y = "Magnitude") + 
        theme_copernicus() + 
        scale_color_manual("q= ", values = mp(c(2,5,6))) + 
        guides(color = "none") +
        scale_x_log10()  +
        no_grid() 

# Phase plot
phase_plot <- 
    ggplot(data = BV_sim_data) + aes(freq, col = as.factor(q)) +
        geom_line(aes(y = phase), size = 1) +
        scale_x_log10() + 
        labs (x = "Frequency (Hz)", y = "Phase (degrees)") +
        theme_copernicus()  +
        no_grid() +
        scale_color_manual("Non-dimensional mass flow rate", values = mp(c(2,5,6))) 

freq_response_plots <- 
    mag_plot + phase_plot  + 
    plot_annotation(tag_levels = "a", tag_suffix = ")") +
    plot_layout(guides = "collect") & 
        theme(legend.position = "bottom",
              legend.box = "horizontal",
              legend.direction = "horizontal",
              legend.margin = margin(1,1,1,1),
              legend.box.margin = margin(1,1,1,1),
              legend.title = element_text(size = 10, face = "bold",  margin = margin(0,5,0,0)),
              legend.text= element_text(size = 10, margin = margin(0,7,0,0)),
              legend.justification = c(1, 0),
              legend.spacing.x = unit(1,'mm'),
              legend.key.size = unit(4, "mm"),
              legend.background = element_rect(fill = alpha("white", .8)))



# Save plot
psave("Fig01.pdf", 
      p = freq_response_plots, 
      height = 3.7,
      output_dir = plot_output_dir)

