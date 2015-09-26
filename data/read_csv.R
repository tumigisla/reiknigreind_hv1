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
hbsv_eftir_ar_fjol <- read.csv("csv/hbsv_eftir_ár_allt_saman_201502261.csv", header = TRUE, skip=1, nrows = 34, encoding = "UTF-8")
hbsv_eftir_ar_ein <- read.csv("csv/hbsv_eftir_ár_allt_saman_201502262.csv", header = TRUE, skip=1, nrows=34, encoding = "UTF-8")
# Fjöldi íbúða.
landshlutar <- read.csv("csv/Landshlutar_201502250.csv", header=TRUE, skip=1, encoding = "UTF-8")
fjoldi_husa_hbsv <- landshlutar[7:27,]
names(fjoldi_husa_hbsv)[1] <- "Ár"
# Samningar + Makaskipti
makaskipti_hbsv <- read.csv('csv/fjoldi_makaskipta_ibudir_hbsv_1993-2006_eftir_kaupdegi0.csv', header = TRUE, dec=',', as.is=TRUE, encoding = "UTF-8")
makaskipti <- makaskipti_hbsv[c(1,3,4)]
makaskipti <- subset(data.frame(custom_aggregate(makaskipti$Makaskipti, list(makaskipti$Ár), sum),
                                extract_column(custom_aggregate(makaskipti$Samningar, list(makaskipti$Ár), sum), 'x')),
                     Group.1 >= 1994)
colnames(makaskipti) <- c('Ár', 'Makaskipti', 'Samningar')
makaskipti_hbsv_1 <- read.csv("csv/Makaskipti_hbsv_201502250.csv", header=TRUE, skip=1, encoding = "UTF-8")
makaskipti_hbsv_1 <- makaskipti_hbsv_1[c(1, 3, 4, 5, 6)]
makaskipti_2006 <- subset(data.frame(custom_aggregate(makaskipti_hbsv_1$Makaskiptasamningar, list(makaskipti_hbsv_1$Ár), sum),
                                extract_column(custom_aggregate(makaskipti_hbsv_1$Sölur, list(makaskipti_hbsv_1$Ár), sum), 'x')),
                                Group.1 >= 1994)
colnames(makaskipti_2006) <- c('Ár', 'Makaskipti', 'Samningar')
makaskipti <- rbind(makaskipti, makaskipti_2006)
makaskipti$Ár <- as.integer(makaskipti$Ár)
makaskipti <- subset(data.frame(custom_aggregate(makaskipti$Makaskipti, list(makaskipti$Ár), sum),
                                extract_column(custom_aggregate(makaskipti$Samningar, list(makaskipti$Ár), sum), 'x')),
                     Group.1 >= 1994)
colnames(makaskipti) <- c('Ár', 'Makaskipti', 'Samningar')
# Fjoldi ibua allt land.
fjoldi_ibuda_allt <- read.csv("csv/Skipting_ibuda_eftir_svfn__201508240.csv", header=TRUE, skip=2, encoding = "UTF-8")
# Fjoldi ibua eftir sveitarfelagi.
years <- 2014:1994
fjoldi_ibuda_hbsv <- data.frame(x=integer(21), y=integer(21), stringsAsFactors=FALSE)
for(i in 1:21){
  fjoldi_ibuda_temp <- read.csv(paste0("csv/Skipting_ibuda_eftir_svfn__20150824", i, ".csv"), header=TRUE, encoding = "UTF-8")
  fjoldi_ibuda_temp <- subset(fjoldi_ibuda_temp, fjoldi_ibuda_temp$Sveitarfélagsnúmer < 2000)
  fjoldi_ibuda_hbsv$x[21 - i + 1] <- years[i]
  fjoldi_ibuda_hbsv$y[21 - i + 1] <- sum(fjoldi_ibuda_temp$Fjöldi.íbúða, na.rm=TRUE)
}
colnames(fjoldi_ibuda_hbsv) <- c('Ár', 'Fjöldi')
# Söluverð
soluverd_alls <- read.csv("csv/Söluverð_á_nýjum_íbúðum_201502250.csv", header=TRUE, skip=1, encoding = "UTF-8")
soluverd_fjol <- read.csv("csv/Söluverð_á_nýjum_íbúðum_201502251.csv", header=TRUE, skip=1, encoding = "UTF-8")
soluverd_ein <- read.csv("csv/Söluverð_á_nýjum_íbúðum_201502252.csv", header=TRUE, skip=1, encoding = "UTF-8")
# Fjöldi sumarhúsa.
sumarhus_landshlutum <- read.csv("csv/Sumarhús_e_landshlutum_24_08_20150.csv", header=TRUE, skip=2, nrows=18, encoding = "UTF-8")
colnames(sumarhus_landshlutum)[1] <- "Ár"


#Interesting (Few years)
leiguverd <- read.csv('csv/arid2014leiguverd_260220150.csv', header=TRUE, skip=3, dec=',', as.is=TRUE, encoding = "UTF-8")
# Skipting eftir gerðum (Few years)
fjoldi_ibuda_gerd_2014 <- read.csv("csv/Skipting_ibuda_eftir_svfn_og_gerd_201508240.csv", header=TRUE, skip=1, encoding = "UTF-8")
fjoldi_ibuda_gerd_2013 <- read.csv("csv/Skipting_ibuda_eftir_svfn_og_gerd_201508241.csv", header=TRUE, skip=1, encoding = "UTF-8")
fjoldi_ibuda_gerd_2012 <- read.csv("csv/Skipting_ibuda_eftir_svfn_og_gerd_201508242.csv", header=TRUE, skip=1, encoding = "UTF-8")
fjoldi_ibuda_gerd_2011 <- read.csv("csv/Skipting_ibuda_eftir_svfn_og_gerd_201508243.csv", header=TRUE, skip=1, encoding = "UTF-8")
# Verð eftir bæjarfélagi(Exists in other tables)
verd_baer <- read.csv("csv/verd_eftir_bæjum_frá19900.csv", header=TRUE, skip=1, encoding = "UTF-8")
setwd(original_dir)