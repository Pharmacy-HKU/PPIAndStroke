## Script name:
## Purpose of script:
## Author: FAN Min
## Date Created: 2023-02-23
## Copyright (c) FAN Min, 2023
## Email: minfan@connect.hku.hk
##
## Notes:
#             1. use all stroke
#             2. LC -> first records in CDARS (Now removed from the analysis, no need to use that)
#             3. ppi_allstroke? ppi_pb0314?
#             4. AFTER 60?  event within (PPI 60 days - end of PPI Rx date)
##
##




# Package loading and environment setting ----------------------------------
options(scipen = 6, digits = 4)
memory.limit(30000000)

library(data.table)
library(haven)
# source("functions/packages.R")       # loads up all the packages we need


# ppi_allstroke <- haven::read_sas("./data/SAS raw files/ppi_allstroke.sas7bdat")

new_cohort <- pblapply(list.files(pattern="conv.xlsx","M:/Cohort Raw Data (do not edit)/Stroke and PPI/cdars converted data/stroke dx",full.names = T),readxl::read_excel)
new_cohort <- rbindlist(new_cohort)
colnames(new_cohort) <- stringr::str_replace_all(gsub("\n","",colnames(new_cohort)), "[^[:alnum:]]", "_")
new_cohort[,Patient_Type__IP_OP_A_E_:=gsub("\n","",Patient_Type__IP_OP_A_E_)]
stroke_A <- new_cohort[Patient_Type__IP_OP_A_E_ %in% c("A"),]

new_ip <- pblapply(list.files(pattern="conv.xlsx","M:/Cohort Raw Data (do not edit)/Stroke and PPI/cdars converted data/stroke ip/",full.names = T),readxl::read_excel)
new_ip <- rbindlist(new_ip)
colnames(new_ip) <- stringr::str_replace_all(gsub("\n","",colnames(new_ip)), "[^[:alnum:]]", "_")
new_ip[,Principal_Diagnosis_Code:=gsub("\n","",Principal_Diagnosis_Code)]

stroke_AI <- rbind(stroke_A[,.(Reference_Key,Sex,Date_of_Birth__yyyy_mm_dd_,Date_of_Registered_Death,icd=All_Diagnosis_Code__ICD9_,Reference_Date,Patient_Type__IP_OP_A_E_)],
                   new_ip[,.(Reference_Key,Sex,Date_of_Birth__yyyy_mm_dd_,Date_of_Registered_Death,icd=Principal_Diagnosis_Code,Reference_Date=Admission_Date__yyyy_mm_dd_,Patient_Type__IP_OP_A_E_="I")])
stroke_AI[,Reference_Date:=ymd(Reference_Date)]
stroke_AI <- stroke_AI[grepl('433.01|^433.11|^433.21|^433.31|^433.81|^433.91|^434|^436|^437.0|^437.1|^430|^431|^432',
                             icd)]
stroke_AI_first <- stroke_AI[,.SD[Reference_Date==min(Reference_Date)],Reference_Key]



# -------------------------------------------------------------------------
# ppi ---------------------------------------------------------------------
# -------------------------------------------------------------------------

ppi_pb_0314 <- as.data.table(haven::read_sas("./data/SAS raw files/ppi_pb_0314op.sas7bdat"))
ppi_pb_0314op <- ppi_pb_0314[!grepl("ASPIRIN|BENZHEXOL|MEFENAMIC",Drug_Name)] #2341849
# /*remove patients who had PPI prescription during 2000-2002*/
ppi_pb_0002 <- as.data.table(haven::read_sas("./data/SAS raw files/ppi_pb_0002.sas7bdat"))
ppi_pb_0314op_rm0002 <- ppi_pb_0314op[!Reference_Key %in% ppi_pb_0002$Reference_Key] #396994

# /*please use the whole datasets to remove patients with ppirxen<ppirxst/ppirxst>dod
# need to update on 11 July 2016*/
ppi_pb_0312 <- as.data.table(haven::read_sas("./data/SAS raw files/ppi_pb_0312.sas7bdat"))
ppi_pb_1314 <- as.data.table(haven::read_sas("./data/SAS raw files/ppi_pb_1314.sas7bdat"))
rm <- rbind(ppi_pb_0312,ppi_pb_1314)[ymd(Prescription_End_Date)<ymd(Prescription_Start_Date)]
rm2 <- ppi_pb_0314op_rm0002[!Date_of_Registered_Death=="" & ymd(Date_of_Birth__yyyy_mm_dd_) > ymd(Date_of_Registered_Death)]
rm3 <- rbind(ppi_pb_0312,ppi_pb_1314)[!Date_of_Registered_Death=="" & ymd(Prescription_Start_Date)> ymd(Date_of_Registered_Death)]
rm_all <- rbind(rm,rm2,rm3) # 1319
rm(rm,rm2,rm3)

ppi_pb_0314op_rm0002 <- ppi_pb_0314op_rm0002[!Reference_Key %in% rm_all$Reference_Key] # 2006712


# /*remove those who had IP PPIs before first OP PPIs and remove patients on non-oral*/

pbppi0314_rm <- rbind(ppi_pb_0312,ppi_pb_1314)[Type_of_Patient__Drug_ %in% c("I","D") | !Route %in% c("ORAL","PO") | Route==""]
ppi_ip_0314 <- pbppi0314_rm[Reference_Key %in% ppi_pb_0314op_rm0002$Reference_Key] #1064229

ppi_pb_0314op_rm0002[, min_op:=min(Prescription_Start_Date), Reference_Key]
ip_op <- merge(ppi_pb_0314op_rm0002,
               ppi_ip_0314[,.(Reference_Key,ip_rxst=Prescription_Start_Date)],
               by="Reference_Key",all.x=T,allow.cartesian = T)

ip_op2 <- ip_op[!is.na(ip_rxst) & ymd(ip_rxst)<=ymd(min_op)]

ppi_pb_0314op_rm0002 <- ppi_pb_0314op_rm0002[!Reference_Key %in% ip_op2$Reference_Key] #1014188 127071


# -------------------------------------------------------------------------
# stop here ---------------------------------------------------------------
# -------------------------------------------------------------------------



ppi_ip_0314_RC <- ppi_ip_0314[!Reference_Key %in% ip_op2$Reference_Key]#178387
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



dt <- as.data.table(readxl::read_excel("./data/ppi and stroke.xls"))
dt_sccs <- dt[,.(Reference_Key,dob,st_st=ymd(Prescription_Start_Date,tz = "UTC"),
                 st_en=ymd(Prescription_End_Date,tz = "UTC"),
                 y1,y2,eventd,age,min_lc,IP_RC,lc12)]
dt_sccs[,`:=`(y1=as.numeric(y1-dob),
              y2=as.numeric(y2-dob),
              st_st=as.numeric(st_st-dob),
              st_en=as.numeric(st_en-dob),
              eventd=as.numeric(eventd-dob),
              id=Reference_Key)]

# dt_sccs[,`:=`(y1=ymd(y1),
#               y2=ymd(y2),
#               st_st=ymd(st_st),
#               st_en=ymd(st_en),
#               eventd=ymd(eventd),
#               dob=ymd(dob),
#               id=Reference_Key)]

dt_sccs[,`:=`(rxst_15th_b=pmax(st_st-14,na.rm = T),
              rxed_15th_b=st_st-1)]
dt_sccs[,`:=`(rxst_1st =as.numeric(NA),rxed_1st =as.numeric(NA),
              rxst_15th=as.numeric(NA),rxed_15th=as.numeric(NA),
              rxst_31st=as.numeric(NA),rxed_31st=as.numeric(NA))]

dt_sccs[as.numeric(st_en-st_st)<14,
        `:=`(rxst_1st=st_st,rxed_1st = st_en)]

dt_sccs[as.numeric(st_en-st_st)>=14 & as.numeric(st_en-st_st)<29 ,
        `:=`(rxst_1st=st_st,rxed_1st = st_st+13,
             rxst_15th=st_st+14,rxed_15th=st_en)]

dt_sccs[as.numeric(st_en-st_st)>=29 & as.numeric(st_en-st_st)<59 ,
        `:=`(rxst_1st=st_st,rxed_1st = st_st+13,
             rxst_15th=st_st+14,rxed_15th=st_st+27,
             rxst_31st=st_st+28,rxed_31st=st_en)]

dt_sccs[as.numeric(st_en-st_st)>=59 ,
        `:=`(rxst_1st=st_st,rxed_1st = st_st+15,
             rxst_15th=st_st+14,rxed_15th=st_st+27,
             rxst_31st=st_st+28,rxed_31st=st_st+59)]


library("SCCS")
options(scipen = 999)
standardsccs(event~rxst_15th_b+rxst_1st+rxst_15th+rxst_31st,indiv=id,
             astart=y1,
             aend = y2,
             adrug=list(rxst_15th_b,rxst_1st,rxst_15th,rxst_31st),
             aedrug = list(rxed_15th_b,rxed_1st,rxed_15th,rxed_31st),
             aevent = eventd,agegrp = 1:109*365,
             data=as.data.frame(dt_sccs))

dt_sccs$dob_ddmmyy <- as.character(format(dt_sccs$dob,format="%d%m%Y"))
abc <-formatdata(indiv=id,
                 astart=y1,
                 aend = y2,
                 adrug=list(rxst_15th_b,rxst_1st,rxst_15th,rxst_31st),
                 aedrug = list(rxed_15th_b,rxed_1st,rxed_15th,rxed_31st),
                 aevent = eventd,agegrp = 1:108*365.25,#dob = dob_ddmmyy,
                 data=as.data.frame(dt_sccs))
setDT(abc)
a <- (abc[indiv==682])

b <- (test2[test2$V1==682,])
a
b

dt[Reference_Key==682]

