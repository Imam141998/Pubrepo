library(tidyverse);library(stringr);library(sqldf);library(SASdates);library(haven);library(hms);
library(lubridate);library(expss)
output<-"C:/Users/Desktop/Rpractice/sdtm"
setwd(output)
rawdata<-"IMAM/Work/02data_raw/Dumps"
setwd(rawdata)
dir()
# combining datasets
dm<-read_sas("C:/Users/Desktop/Rpractice/anadata/dm.sas7bdat") %>% select(USUBJID,RFSTDTC,RFICDTC,SUBJID,RFENDTC)
dmx<-merge(dm,ex,by="USUBJID")
ae<-read_sas("ae.sas7bdat") %>% filter(AETERM!="") %>% select(Sub_No,AESTTM,AESPTM,AESTD,AEENDDTC)
ae_cod<-read_sas("ae_coded.sas7bdat") %>% filter(AETERM!="") %>% select(-c(AESTTM,AESPTM,AESTD,AEENDDTC))

# Date derivation
ae_<-ae %>% inner_join(ae_cod,by="Sub_No") %>% mutate(AESTDTC=paste0(as.Date(AESTD),"T",as_hms(AESTTM)),
  AEENDTC1=paste0(as.Date(AEENDDTC),"T",as_hms(AESPTM)))%>% 
  mutate(AESTDTCN=as.Date(substr(AESTDTC,1,10)),
         AENDTCN=as.Date(substr(AEENDTC1,1,10))) %>% 

  mutate(AELLTCD=as.numeric(AELLTCD),
         AEHLTCD=as.numeric(AEHLTCD),
         AEHLGTCD=as.numeric(AEHLGTCD),AESOCCD=as.numeric(AESOCCD)) %>%
  rename(SUBJID=Sub_No)

# epoch derivation
ex<-read_sas("C:/Users/Desktop/Rpractice/anadata/ex.sas7bdat") %>%
  mutate(XSTDTC=as.Date(substr(EXSTDTC,1,10))) %>% 
  pivot_wider(id_cols = "USUBJID",
              names_from = EPOCH,
              values_from =XSTDTC )
ds<-read_sas("ds.sas7bdat") 	%>% mutate(DSDAT=DSDTC) %>% select(SUBJID=SUB_NO,DSDAT)
dm_ds<-inner_join(dm,ds,by="SUBJID")

 ae_dm<-inner_join(ae_,dm_ds,by="SUBJID") %>% 
   mutate(RFSTDTCN=as.Date(substr(RFSTDTC,1,10)),RFENDTCN=as.Date(substr(RFENDTC,1,10))) 


ae_x<-left_join(ae_dm,ex,by="USUBJID") %>% mutate(EPOCH=case_when(as.numeric(AESTDTCN)<=as.numeric(RFSTDTCN) ~"SCREENING",
 as.numeric(`TREATMENT  1`)<=as.numeric(AESTDTCN) & as.numeric(AESTDTCN)< as.numeric(`TREATMENT  2`)~"TREATMENT 1",
 as.numeric(`TREATMENT  2`)<=as.numeric(AESTDTCN)~"TREATMENT 2",
 as.numeric(AESTDTCN)>=as.numeric(DSDAT)~"FOLLOW-UP"))
# Day calculation
ae1<-ae_x %>% mutate(AESTDY=ifelse(as.numeric(AESTDTCN)<as.numeric(RFSTDTCN),as.numeric(AESTDTCN)-as.numeric(RFSTDTCN),
                                      as.numeric(AESTDTCN)-as.numeric(RFSTDTCN)+1),
                     AEENDY=ifelse(as.numeric(AENDTCN)<as.numeric(RFSTDTCN),as.numeric(AENDTCN)-as.numeric(RFSTDTCN),
                                   as.numeric(AENDTCN)-as.numeric(RFSTDTCN)+1)) %>% rename(AEENDTC=AEENDTC1)





