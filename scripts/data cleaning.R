## Script name: data cleanning.R
## Purpose of script: for PPI and Stroke
## Author: FAN Min
## Date Created: 2023-02-22
## Copyright (c) FAN Min, 2023
## Email: minfan@connect.hku.hk
##
## Notes:
##
##




# Package loading and environment setting ----------------------------------
options(scipen = 6, digits = 4)
memory.limit(30000000)

library(data.table) # data cleaning
library(pbapply) #progress bar
library(lubridate)

new_cohort <- pblapply(list.files(pattern="conv.xlsx","M:/Cohort Raw Data (do not edit)/Stroke and PPI/cdars converted data/stroke dx",full.names = T),readxl::read_excel)
new_cohort <- rbindlist(new_cohort)
colnames(new_cohort) <- stringr::str_replace_all(gsub("\n","",colnames(new_cohort)), "[^[:alnum:]]", "_")


new_ip <- pblapply(list.files(pattern="conv.xlsx","M:/Cohort Raw Data (do not edit)/Stroke and PPI/cdars converted data/stroke ip/",full.names = T),readxl::read_excel)
new_ip <- rbindlist(new_ip)
colnames(new_ip) <- stringr::str_replace_all(gsub("\n","",colnames(new_ip)), "[^[:alnum:]]", "_")

colnames(stroke)



# stroke ------------------------------------------------------------------
stroke <- haven::read_sas("./data/SAS raw files/dx_all9315jj.sas7bdat")
setDT(stroke)
stroke_opppi <- stroke[grepl('433.01|^433.11|^433.21|^433.31|^433.81|^433.91|^434|^436|^437.0|^437.1|^430|^431|^432',All_Diagnosis_Code__ICD9_)]
# /* only find those stroke patients in OP PPI prescriptions*/
ppi_allstroke <- haven::read_sas("./data/SAS raw files/ppi_allstroke.sas7bdat")
setDT(ppi_allstroke)



ppi_pb_0314 <- as.data.table(haven::read_sas("./data/SAS raw files/ppi_pb_0314op.sas7bdat"))
opppi_stroke <- ppi_pb_0314[Reference_Key %in% ppi_allstroke$Reference_Key] #468260
opppi_stroke <- opppi_stroke[!grepl("ASPIRIN|BENZHEXOL|MEFENAMIC",Drug_Name)] #468259
setDT(opppi_stroke)

# /*remove patients who had PPI prescription during 2000-2002*/
ppi_pb_0002 <- as.data.table(haven::read_sas("./data/SAS raw files/ppi_pb_0002.sas7bdat"))
opppi_stroke_oralclean <- opppi_stroke[!Reference_Key %in% ppi_pb_0002$Reference_Key] #396994


# /*please use the whole datasets to remove patients with ppirxen<ppirxst/ppirxst>dod
# need to update on 11 July 2016*/
ppi_pb_0312 <- as.data.table(haven::read_sas("./data/SAS raw files/ppi_pb_0312.sas7bdat"))
ppi_pb_1314 <- as.data.table(haven::read_sas("./data/SAS raw files/ppi_pb_1314.sas7bdat"))
rm <- rbind(ppi_pb_0312,ppi_pb_1314)[ymd(Prescription_End_Date)<ymd(Prescription_Start_Date)]
rm2 <- opppi_stroke_oralclean[!Date_of_Registered_Death=="" & ymd(Date_of_Birth__yyyy_mm_dd_) > ymd(Date_of_Registered_Death)]
rm3 <- rbind(ppi_pb_0312,ppi_pb_1314)[!Date_of_Registered_Death=="" & ymd(Prescription_Start_Date)> ymd(Date_of_Registered_Death)]
rm_all <- rbind(rm,rm2,rm3)
rm(rm,rm2,rm3)

opppi_stroke_oralclean <- opppi_stroke_oralclean[!Reference_Key %in% rm_all$Reference_Key] #395595

# /*remove those who had IP PPIs before first OP PPIs and remove patients on non-oral*/
pbppi0314_rm <- rbind(ppi_pb_0312,ppi_pb_1314)[Type_of_Patient__Drug_ %in% c("I","D") | !Route %in% c("ORAL","PO") | Route==""]
ppi_ip_0314 <- pbppi0314_rm[Reference_Key %in% opppi_stroke_oralclean$Reference_Key] #1064229


opppi_stroke_oralclean[, min_op:=min(Prescription_Start_Date), Reference_Key]

merge(opppi_stroke_oralclean,
      ppi_ip_0314[,.(Reference_Key,Prescription_Start_Date)],
      by="Reference_Key",allow.cartesian = T)




a

# cohort ------------------------------------------------------------------
dx <- haven::read_sas("./data/SAS raw files/allstroke_date.sas7bdat") # 49308 records
setDT(dx)




# rx ----------------------------------------------------------------------
rx <- fread("./data/SAS raw files/alldrug9314.txt") # 64387977


list.files("data/")



