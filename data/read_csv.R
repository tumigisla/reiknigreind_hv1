original_dir <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

# Hjálparföll

# xList er þau gögn sem á að aggregate-a.
# byList er sá listi sem aggregate-a á eftir.
custom_aggregate <- function(xList, byList, func)
{
  return(aggregate(as.numeric(lapply(xList, function (x) {replace(x, is.na(x) | x == '.', 0)}))
                   ,by=byList, FUN=func, na.rm=TRUE, na.naction=NULL))
}

# dataentity er t.d. data.frame eða data.table
# columnname er nafn þess dálks sem við viljum einangra úr dataentity
extract_column <- function(dataentity, columnname)
{
  return(subset(dataentity, select=c(columnname)))
}

# Verð eftir ári (WELL FORMATED).
hbsv_eftir_ar_all <- read.csv("csv/hbsv_eftir_ár_allt_saman_201502260.csv", header = TRUE, skip=1, nrows=34, encoding = "UTF-8")
hbsv_eftir_ar_all <- subset(hbsv_eftir_ar_all, hbsv_eftir_ar_all$Ár >= 1994)
hbsv_eftir_ar_all <- hbsv_eftir_ar_all[, c(1, 2, 3, 4, 6)]
hbsv_eftir_ar_all$Kaupverð.á.fermeter..krónur. <- round(hbsv_eftir_ar_all$Kaupverð.á.fermeter..krónur./1000.0)
colnames(hbsv_eftir_ar_all) <- c('Ár', 'Fjöldi seldra íbúðahúsnæða á HBSV.', 'Meðal flatarmál seldra íbúðarhúsnæða á HBSV. [m2]', "Meðal kaupverð íbúðarhúsnæðis á HBSV. [þús. kr]",
                                 'Fermetraverð á íbúðarhúsnæði á HBSV. [þús. kr.]')
hbsv_eftir_ar_fjol <- read.csv("csv/hbsv_eftir_ár_allt_saman_201502261.csv", header = TRUE, skip=1, nrows = 34, encoding = "UTF-8")
hbsv_eftir_ar_fjol <- subset(hbsv_eftir_ar_fjol, hbsv_eftir_ar_fjol$Ár >= 1994)
hbsv_eftir_ar_fjol <- hbsv_eftir_ar_fjol[, c(1, 2, 3, 4, 6)]
hbsv_eftir_ar_fjol$Kaupverð.fjölbýlis.á.fermeter..krónur. <- round(hbsv_eftir_ar_fjol$Kaupverð.fjölbýlis.á.fermeter..krónur./1000.0)
colnames(hbsv_eftir_ar_fjol) <- c('Ár', 'Fjöldi seldra íbúða í fjölbýli á HBSV.', 'Meðal flatarmál seldra íbúða í fjölbýli á HBSV. [m2]', "Meðal kaupverð íbúða í fjölbýli á HBSV. [þús. kr]",
                                 'Fermetraverð á íbúðum í fjölbýli á HBSV. [þús. kr.]')
hbsv_eftir_ar_ein <- read.csv("csv/hbsv_eftir_ár_allt_saman_201502262.csv", header = TRUE, skip=1, nrows=34, encoding = "UTF-8")
hbsv_eftir_ar_ein <- subset(hbsv_eftir_ar_ein, hbsv_eftir_ar_ein$Ár >= 1994)
hbsv_eftir_ar_ein <- hbsv_eftir_ar_ein[, c(1, 2, 3, 4, 6)]
hbsv_eftir_ar_ein$Kaupverð.sérbýlis.á.fermeter..krónur. <- round(hbsv_eftir_ar_ein$Kaupverð.sérbýlis.á.fermeter..krónur./1000.0)
colnames(hbsv_eftir_ar_ein) <- c('Ár', 'Fjöldi seldra íbúða í sérbýli á HBSV.', 'Meðal flatarmál seldra íbúða í sérbýli á HBSV. [m2]', "Meðal kaupverð seldra íbúða í sérbýli á HBSV. [þús. kr]",
                                  'Fermetraverð íbúða í sérbýli á HBSV. [þús. kr.]')
# Samningar + Makaskipti
makaskipti_hbsv <- read.csv('csv/fjoldi_makaskipta_ibudir_hbsv_1993-2006_eftir_kaupdegi0.csv', header = TRUE, dec=',', as.is=TRUE, encoding = "UTF-8")
makaskipti <- makaskipti_hbsv[c(1,3,4)]
remove(makaskipti_hbsv)
makaskipti <- subset(data.frame(custom_aggregate(makaskipti$Makaskipti, list(makaskipti$Ár), sum),
                                extract_column(custom_aggregate(makaskipti$Samningar, list(makaskipti$Ár), sum), 'x')),
                     Group.1 >= 1994)
colnames(makaskipti) <- c('Ár', 'Makaskipti', 'Samningar')
makaskipti_hbsv_1 <- read.csv("csv/Makaskipti_hbsv_201502250.csv", header=TRUE, skip=1, encoding = "UTF-8")
makaskipti_hbsv_1 <- makaskipti_hbsv_1[c(1, 3, 4, 5, 6)]
makaskipti_2006 <- subset(data.frame(custom_aggregate(makaskipti_hbsv_1$Makaskiptasamningar, list(makaskipti_hbsv_1$Ár), sum),
                                extract_column(custom_aggregate(makaskipti_hbsv_1$Sölur, list(makaskipti_hbsv_1$Ár), sum), 'x')),
                                Group.1 >= 1994)
remove(makaskipti_hbsv_1)
colnames(makaskipti_2006) <- c('Ár', 'Makaskipti', 'Samningar')
makaskipti <- rbind(makaskipti, makaskipti_2006)
remove(makaskipti_2006)
makaskipti$Ár <- as.integer(makaskipti$Ár)
makaskipti <- subset(data.frame(custom_aggregate(makaskipti$Makaskipti, list(makaskipti$Ár), sum),
                                extract_column(custom_aggregate(makaskipti$Samningar, list(makaskipti$Ár), sum), 'x')),
                     Group.1 >= 1994)
colnames(makaskipti) <- c('Ár', 'Makaskipti með íbúðarhúsnæði', 'Fjöldi seldra íbúðarhúsnæða')
# Fjoldi ibuða allt land.
fjoldi_ibuda_allt <- read.csv("csv/Skipting_ibuda_eftir_svfn__201508240.csv", header=TRUE, skip=2, encoding = "UTF-8")
colnames(fjoldi_ibuda_allt) <- c('Ár', 'Fjöldi íbúðarhúsnæða')
# Fjoldi ibua eftir sveitarfelagi.
years <- 2014:1994
fjoldi_ibuda_hbsv <- data.frame(x=integer(21), y=integer(21), stringsAsFactors=FALSE)
for(i in 1:21){
  fjoldi_ibuda_temp <- read.csv(paste0("csv/Skipting_ibuda_eftir_svfn__20150824", i, ".csv"), header=TRUE, encoding = "UTF-8")
  fjoldi_ibuda_temp <- subset(fjoldi_ibuda_temp, fjoldi_ibuda_temp$Sveitarfélagsnúmer < 2000)
  fjoldi_ibuda_hbsv$x[21 - i + 1] <- years[i]
  fjoldi_ibuda_hbsv$y[21 - i + 1] <- sum(fjoldi_ibuda_temp$Fjöldi.íbúða, na.rm=TRUE)
  remove(fjoldi_ibuda_temp)
}
colnames(fjoldi_ibuda_hbsv) <- c('Ár', 'Fjöldi íbúðarhúsnæða á HBSV.')
# Söluverð
soluverd_alls <- read.csv("csv/Söluverð_á_nýjum_íbúðum_201502250.csv", header=TRUE, skip=1, encoding = "UTF-8")
soluverd_alls <- subset(soluverd_alls, soluverd_alls$Ár >= 1994)
soluverd_alls$Kaupverð.á.fermeter <- round(soluverd_alls$Kaupverð.á.fermeter/1000.0)
soluverd_alls <- soluverd_alls[, c(1, 3, 4)]
colnames(soluverd_alls) <- c("Ár", "Fermetraverð á nýju íbúðarhúsnæði [þús. kr]", "Fjöldi seldra nýrra íbúðarhúsnæða")
soluverd_fjol <- read.csv("csv/Söluverð_á_nýjum_íbúðum_201502251.csv", header=TRUE, skip=1, encoding = "UTF-8")
soluverd_fjol <- subset(soluverd_fjol, soluverd_fjol$Ár >= 1994)
soluverd_fjol$Kaupverð.á.fermeter <- round(soluverd_fjol$Kaupverð.á.fermeter/1000.0)
soluverd_fjol <- soluverd_fjol[, c(1, 3, 4)]
colnames(soluverd_fjol) <- c("Ár", "Fermetraverð á nýjum íbúðum í fjölbýli [þús. kr]", "Fjöldi seldra nýrra íbúða í fjölbýli")
soluverd_ein <- read.csv("csv/Söluverð_á_nýjum_íbúðum_201502252.csv", header=TRUE, skip=1, encoding = "UTF-8")
soluverd_ein <- subset(soluverd_ein, soluverd_ein$Ár >= 1994)
soluverd_ein$Kaupverð.á.fermeter <- round(soluverd_ein$Kaupverð.á.fermeter/1000.0)
soluverd_ein <- soluverd_ein[, c(1, 3, 4)]
colnames(soluverd_ein) <- c("Ár", "Fermetraverð á nýjum íbúðum í sérbýli [þús. kr]", "Fjöldi seldra nýrra íbúða í sérbýli")
# Fjöldi sumarhúsa.
sumarhus_landshlutum <- read.csv("csv/Sumarhús_e_landshlutum_24_08_20150.csv", header=TRUE, skip=2, nrows=18, encoding = "UTF-8")
sumarhus_landshlutum <- sumarhus_landshlutum[, c(1, 2, 10)]
colnames(sumarhus_landshlutum) <- c("Ár", "Fjöldi sumarhúsa á HBSV", "Fjöldi sumarhúsa")

setwd(original_dir)