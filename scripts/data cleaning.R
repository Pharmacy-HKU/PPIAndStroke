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

shrink_interval <- function(data,idc,st,ed,gap=1){
  data <- copy(data[,.(id=get(idc),
                       st=lubridate::ymd(get(st)),
                       ed=lubridate::ymd(get(ed)))])
  setorder(data,id,st)
  output <- data[,indx:=c(0, cumsum(as.numeric(shift(st,type="lead"))>
                                      cummax(as.numeric(ed)+gap))[-.N]),id
  ][,.(st=min(st),ed=max(ed)),.(id,indx)]
  setnames(output,c("st","ed"),c(st,ed))
  return(output)
}

new_cohort <- pblapply(list.files(pattern="conv.xlsx","M:/Cohort Raw Data (do not edit)/Stroke and PPI/cdars converted data/stroke dx",full.names = T),readxl::read_excel)
new_cohort <- rbindlist(new_cohort)
colnames(new_cohort) <- stringr::str_replace_all(gsub("\n","",colnames(new_cohort)), "[^[:alnum:]]", "_")
new_cohort[,Patient_Type__IP_OP_A_E_:=gsub("\n","",Patient_Type__IP_OP_A_E_)]
new_cohort[Patient_Type__IP_OP_A_E_ %in% c("I","A"),.SD[Reference_Key],Reference_Key]



new_ip <- pblapply(list.files(pattern="conv.xlsx","M:/Cohort Raw Data (do not edit)/Stroke and PPI/cdars converted data/stroke ip/",full.names = T),readxl::read_excel)
new_ip <- rbindlist(new_ip)
colnames(new_ip) <- stringr::str_replace_all(gsub("\n","",colnames(new_ip)), "[^[:alnum:]]", "_")
new_ip[,Principal_Diagnosis_Code:=gsub("\n","",Principal_Diagnosis_Code)]
new_ip[grepl('433.01|^433.11|^433.21|^433.31|^433.81|^433.91|^434|^436|^437.0|^437.1|^430|^431|^432',Principal_Diagnosis_Code),.SD[ymd(Admission_Date__yyyy_mm_dd_)==min(Admission_Date__yyyy_mm_dd_)],Reference_Key]

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


ip_op <- merge(opppi_stroke_oralclean,
               ppi_ip_0314[,.(Reference_Key,ip_rxst=Prescription_Start_Date)],
               by="Reference_Key",all.x=T,allow.cartesian = T)

ip_op2 <- ip_op[!is.na(ip_rxst) & ymd(ip_rxst)<=ymd(min_op)]


opppi_stroke_oralclean_3 <- opppi_stroke_oralclean[!Reference_Key %in% ip_op2$Reference_Key]
#127071

ppi_ip_0314_RC <- ppi_ip_0314[!Reference_Key %in% ip_op2$Reference_Key]
#178387
ppi_ip_0314_RC[,IP_RC:=min(Prescription_Start_Date),Reference_Key]

# /*key LC data into the dataset*/

pat_lc <- as.data.table(haven::read_sas("./data/SAS raw files/pat_lc.sas7bdat"))

opppi_stroke_oralclean_3 <- merge(opppi_stroke_oralclean_3,pat_lc,by="Reference_Key") # 127071

# /*key right censored IP PPIs/other routes into the dataset*/

opppi_stroke_oralclean_3 <- merge(opppi_stroke_oralclean_3,
                                  unique(ppi_ip_0314_RC[,.(Reference_Key,IP_RC)]),
                                  by="Reference_Key",all.x=T)#127071

opppi_stroke_oralclean_3[,`:=`(lcl2=min_lc+365,
                               y1=ymd("20030101"),
                               y2=ymd("20141231"))
][,`:=`(st_st=pmax(ymd(Date_of_Birth__yyyy_mm_dd_),y1,na.rm = T),
        st_en=pmin(ymd(Date_of_Registered_Death),ymd(y2),ymd(IP_RC),na.rm = T))]

remove <- opppi_stroke_oralclean_3[st_st>st_en | ymd(Prescription_End_Date)< st_st]

opppi_stroke_oralclean_3 <- opppi_stroke_oralclean_3[ymd(Prescription_Start_Date)<=st_en]#59766

opppi_stroke_oralclean_3 <- opppi_stroke_oralclean_3[!Reference_Key %in% remove$Reference_Key]

oralclean_coh1 <- opppi_stroke_oralclean_3

# after 30 days overlapping
remove <- oralclean_coh1[st_st>st_en | ymd(Prescription_End_Date)<st_st]
#0
oralclean_coh1 <- oralclean_coh1[ymd(Prescription_Start_Date)<=st_en]

oralclean_coh1 <- oralclean_coh1[!Reference_Key %in% remove$Reference_Key]

oralclean_coh1[ymd(Prescription_Start_Date)< st_st & ymd(Prescription_End_Date)>= st_st,]
oralclean_coh1[ymd(Prescription_End_Date)> st_en & ymd(Prescription_Start_Date)<= st_en,]


temp <- shrink_interval(oralclean_coh1,id = "Reference_Key",
                        st = "Prescription_Start_Date",ed = "Prescription_End_Date",gap=30)
setnames(temp,"id","Reference_Key")

oralclean_coh1 <- merge(unique(oralclean_coh1[,.(Reference_Key,Sex,Date_of_Birth__yyyy_mm_dd_,Exact_date_of_birth,
                                                 Date_of_Registered_Death,Exact_date_of_death,
                                        Death_Cause__Main_Cause_,Prescription_Start_Date,
                                        min_op,min_lc,IP_RC,lcl2,y1,y2,st_st,st_en)]),
               temp[,.(Reference_Key,Prescription_Start_Date=as.character(Prescription_Start_Date),Prescription_End_Date)],
               by=c("Reference_Key","Prescription_Start_Date"),all.y=T) # 20467
oralclean_coh1[,`:=`(ppirxst=ymd(Prescription_Start_Date),
                     ppirxen=ymd(Prescription_End_Date))]
# There are huge differnece between SAS and R codes during the merging step. I
# think it's ok since most issue are coming from the other records instead of
# date information.


# as.data.table(merge(as.data.frame.table(table(oralclean_coh1$Reference_Key)),as.data.frame.table(table(abc$Reference_Key)),by="Var1"))[!Freq.x==Freq.y]
# as.data.table(merge(abcd[,.N,id][,setnames(.SD,"id","Reference_Key")],
#                     abc[,.N,Reference_Key],by="Reference_Key"),all=T)[!N.x==N.y]

# after merging the overlapping Rx interval
remove <- oralclean_coh1[st_st>st_en| ppirxen <st_st]
#0
oralclean_coh1 <- oralclean_coh1[ppirxst<=st_en]
oralclean_coh1 <- oralclean_coh1[!Reference_Key %in% remove$Reference_Key]


oralclean_coh1[ppirxst<st_st & ppirxen>=st_st,ppirxst:=st_st]
oralclean_coh1[ppirxen>st_en & ppirxst<=st_en,ppirxen:=st_en]

oralclean_coh1[,uniqueN(Reference_Key)]

# *******************************************
#   identify stroke using admission date,
# use only A&E and inpatient D1 data**********
# *******************************************

ppi_allstroke[,refd:=ymd(Reference_Date)]







# cohort ------------------------------------------------------------------
dx <- haven::read_sas("./data/SAS raw files/allstroke_date.sas7bdat") # 49308 records
setDT(dx)




# rx ----------------------------------------------------------------------
rx <- fread("./data/SAS raw files/alldrug9314.txt") # 64387977


list.files("data/")



