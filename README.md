# Theory and experiment of the short-time eddy accumulation method

This repository contains data and scripts needed to reproduce the figures of
Emad and Siebicke (2022)

**True eddy accumulation – Part 2: Theory and experiment of the short-time eddy accumulation method**

Accepted for final publication in Atmospheric Measurement Techniques  
[![DOI:10.5194/amt-2022-164](https://img.shields.io/badge/doi-10.5194%2Famt--2022--164-blue)](https://doi.org/10.5194/amt-2022-164)

The publication version is archived on zenodo  
[![DOI](https://zenodo.org/badge/578288089.svg)](https://zenodo.org/badge/latestdoi/578288089)


Abstract

> A new variant of the eddy accumulation method for measuring atmospheric
> exchange is derived and a prototype sampler is evaluated. The new method, termed
> short-time eddy accumulation (STEA), overcomes the requirement of fixed
> accumulation intervals in the true eddy accumulation method (TEA) and enables
> the sampling system to run in a continuous flow-through mode. STEA enables
> adaptive time-varying accumulation intervals which improves the system’s dynamic
> range and brings many advantages to flux measurement and calculation. The STEA
> method was successfully implemented and deployed to measure CO2 fluxes over an
> agricultural field in Braunschweig, Germany. The measured fluxes matched very
> well against a conventional eddy covariance system (slope of 1.04, R^2 of 0.86).
> We provide a detailed description of the setup and operation of the STEA system
> in the continuous flow-through mode, devise an empirical correction for the
> effect of buffer volumes, and describe the important considerations for the
> successful operation of the STEA method. The STEA method reduces the bias and
> uncertainty in the measured fluxes compared to conventional TEA and creates new
> ways to design eddy accumulation systems with finer control over sampling and
> accumulation. The results encourage the application of STEA for measuring fluxes
> of more challenging atmospheric constituents such as reactive species. This
> paper is Part 2 of a two-part series on true eddy accumulation.
 
 
## Data format
Data are provided under the directory `data` in two different formats:
- `rds`: native R serialization format, convenient and recommended for loading the data
  into R.
- `csv`: for intolerability, a copy of the data is provided in csv format.
 
### Metadata
Metadata for all files is stored under `data/metadata`.
The metadata contains information about variables description and units.

## How to reproduce
To reproduce the figures in the paper, you will need to run the individual
scripts associated with each figure. 
The scripts are  found under `scripts` directory.
The name of each script indicates the name of the figure it produces. 
Simply run the scripts in order to generate the figures.
The resulting figures will be saved under `figures` directory.

Additionally, you can clone the repository and run `create-all-figures.sh` to
reproduce all the figures.
 

## Requirements

The font [Carrois Gothic](https://fonts.google.com/specimen/Carrois+Gothic) is
required for the figures.

R packages in `scripts/01-deps.R` are needed.
Below is a full R session info.

### R session info
<details>
   <summary>sessionInfo()</summary>
 
   ```R
   > sessionInfo()
     R version 4.2.2 (2022-10-31)
     Platform: x86_64-pc-linux-gnu (64-bit)
     Running under: Manjaro Linux

     Matrix products: default
     BLAS/LAPACK: /opt/intel/oneapi/mkl/2022.1.0/lib/intel64/libmkl_gf_lp64.so.2

     locale:
      [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
      [3] LC_TIME=de_DE.UTF-8        LC_COLLATE=en_US.UTF-8    
      [5] LC_MONETARY=de_DE.UTF-8    LC_MESSAGES=en_US.UTF-8   
      [7] LC_PAPER=de_DE.UTF-8       LC_NAME=C                 
      [9] LC_ADDRESS=C               LC_TELEPHONE=C            
     [11] LC_MEASUREMENT=de_DE.UTF-8 LC_IDENTIFICATION=C       

     attached base packages:
     [1] stats     graphics  grDevices utils     datasets  methods   base     

     other attached packages:
     [1] lubridate_1.9.0   timechange_0.1.1  data.table_1.14.6 patchwork_1.1.2  
     [5] latex2exp_0.9.6   lmodel2_1.7-3     ggplot2_3.3.6     colorout_1.2-2   

     loaded via a namespace (and not attached):
      [1] pillar_1.8.0      compiler_4.2.2    R.methodsS3_1.8.2 R.utils_2.12.2   
      [5] tools_4.2.2       lifecycle_1.0.1   tibble_3.1.8      gtable_0.3.0     
      [9] pkgconfig_2.0.3   rlang_1.0.4       DBI_1.1.3         cli_3.3.0        
     [13] withr_2.5.0       dplyr_1.0.10      stringr_1.4.0     generics_0.1.3   
     [17] vctrs_0.4.1       grid_4.2.2        tidyselect_1.1.2  glue_1.6.2       
     [21] R6_2.5.1          fansi_1.0.3       purrr_0.3.5       farver_2.1.1     
     [25] magrittr_2.0.3    scales_1.2.0      assertthat_0.2.1  colorspace_2.0-3 
     [29] utf8_1.2.2        stringi_1.7.8     munsell_0.5.0     R.oo_1.25.0     
 ```
 
 
</details>



