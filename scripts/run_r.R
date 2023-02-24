## Script name:
## Purpose of script:
## Author: FAN Min
## Date Created: 2023-02-23
## Copyright (c) FAN Min, 2023
## Email: minfan@connect.hku.hk
##
## Notes:
##
##




# Package loading and environment setting ----------------------------------
options(scipen = 6, digits = 4)
memory.limit(30000000)

library(data.table)
library(haven)
# source("functions/packages.R")       # loads up all the packages we need


ppi_allstroke <- haven::read_sas("./data/SAS raw files/ppi_allstroke.sas7bdat")
