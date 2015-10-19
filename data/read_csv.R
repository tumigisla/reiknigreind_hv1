library(plyr)

# Script sem les inn gögn frá þjóðskrá tengd íbúðarverði. Gögnin voru fengin af netsíðu þjóðskrár á
# excel formi og breytt yfir á CSV.

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

###############
# Gögn yfir söluverð íbúðarhúsnæðis á höfuðborgarsvæðinu.
# Data variable: hbsv_eftir_ar_all
###############
hbsv_eftir_ar_all <- read.csv("csv/hbsv_eftir_ár_allt_saman_201502260.csv", header = TRUE, skip=1,
                              nrows=34, encoding = "UTF-8")
# Til að samræma þessi gögn við gögn frá Hagstofunni aðeins notast við ár eftir 1993.
hbsv_eftir_ar_all <- subset(hbsv_eftir_ar_all, hbsv_eftir_ar_all$Ár >= 1994)
# Sleppa úr gögn yfir staðgreiðsluverð.
hbsv_eftir_ar_all <- hbsv_eftir_ar_all[, c(1, 2, 3, 4, 6)]
# Endurskala fermetraverð í þúsundir króna, til að samræma við önnur gögn í krónutölu.
hbsv_eftir_ar_all$Kaupverð.á.fermeter..krónur. <- round(hbsv_eftir_ar_all$Kaupverð.á.fermeter..krónur./1000.0)
# Endurskýra dálkanöfn til útskýringa á innihaldi.
colnames(hbsv_eftir_ar_all) <- c('Ár', 'Fjöldi seldra íbúðahúsnæða á HBSV.', 'Meðal flatarmál seldra íbúðarhúsnæða á HBSV. [m\U00B2]',
                                 "Meðal kaupverð íbúðarhúsnæðis á HBSV. [þús. kr]", 'Fermetraverð á íbúðarhúsnæði á HBSV. [þús. kr.]')

###############
# Gögn yfir söluverð íbúða í fjölbýli á höfuðborgarsvæðinu.
# Data variable: hbsv_eftir_ar_fjol
###############
# Sömu aðgerðir og fyrir öll íbúðarhúsnæði.
hbsv_eftir_ar_fjol <- read.csv("csv/hbsv_eftir_ár_allt_saman_201502261.csv", header = TRUE, skip=1,
                               nrows = 34, encoding = "UTF-8")
hbsv_eftir_ar_fjol <- subset(hbsv_eftir_ar_fjol, hbsv_eftir_ar_fjol$Ár >= 1994)
hbsv_eftir_ar_fjol <- hbsv_eftir_ar_fjol[, c(1, 2, 3, 4, 6)]
hbsv_eftir_ar_fjol$Kaupverð.fjölbýlis.á.fermeter..krónur. <- round(hbsv_eftir_ar_fjol$Kaupverð.fjölbýlis.á.fermeter..krónur./1000.0)
colnames(hbsv_eftir_ar_fjol) <- c('Ár', 'Fjöldi seldra íbúða í fjölbýli á HBSV.', 'Meðal flatarmál seldra íbúða í fjölbýli á HBSV. [m\U00B2]',
                                  "Meðal kaupverð íbúða í fjölbýli á HBSV. [þús. kr]", 'Fermetraverð á íbúðum í fjölbýli á HBSV. [þús. kr.]')

###############
# Gögn yfir söluverð íbúða í sérbýli á höfuðborgarsvæðinu.
# Data variable: hbsv_eftir_ar_ein
###############
# Sömu aðgerir og fyrir öll íbúðarhúsnæði.
hbsv_eftir_ar_ein <- read.csv("csv/hbsv_eftir_ár_allt_saman_201502262.csv", header = TRUE, skip=1, nrows=34, encoding = "UTF-8")
hbsv_eftir_ar_ein <- subset(hbsv_eftir_ar_ein, hbsv_eftir_ar_ein$Ár >= 1994)
hbsv_eftir_ar_ein <- hbsv_eftir_ar_ein[, c(1, 2, 3, 4, 6)]
hbsv_eftir_ar_ein$Kaupverð.sérbýlis.á.fermeter..krónur. <- round(hbsv_eftir_ar_ein$Kaupverð.sérbýlis.á.fermeter..krónur./1000.0)
colnames(hbsv_eftir_ar_ein) <- c('Ár', 'Fjöldi seldra íbúða í sérbýli á HBSV.', 'Meðal flatarmál seldra íbúða í sérbýli á HBSV. [m\U00B2]',
                                 "Meðal kaupverð seldra íbúða í sérbýli á HBSV. [þús. kr]", 'Fermetraverð íbúða í sérbýli á HBSV. [þús. kr.]')

###############
# Gögn yfir fjölda kaupsamninga og makaskipta á íbúðarhúsnæði fyrir landið allt.
# Data variable: makaskipti
###############
# Gögnin eru í tveim skjölum, eitt með gögn frá 1993 - 2006, og eitt með gögn frá 2006 - 2014.
makaskipti_hbsv <- read.csv('csv/fjoldi_makaskipta_ibudir_hbsv_1993-2006_eftir_kaupdegi0.csv', header = TRUE,
                            dec=',', as.is=TRUE, encoding = "UTF-8")
# Safna gögnum saman eftir árum.
makaskipti <- makaskipti_hbsv[c(1,3,4)]
makaskipti <- subset(data.frame(custom_aggregate(makaskipti$Makaskipti, list(makaskipti$Ár), sum),
                                extract_column(custom_aggregate(makaskipti$Samningar, list(makaskipti$Ár), sum), 'x')),
                     Group.1 >= 1994)
colnames(makaskipti) <- c('Ár', 'Makaskipti', 'Samningar')
# Les inn gögn frá 2006 - 2014.
makaskipti_hbsv_1 <- read.csv("csv/Makaskipti_hbsv_201502250.csv", header=TRUE, skip=1, encoding = "UTF-8")
# Sleppi út upplýsingum yfir íbúðir seldar með makaskiptum + lausafé, því ekki í samræmi við fyrri gögn.
# Held inni lausafé, áhugaverðar tölur.
makaskipti_hbsv_1 <- makaskipti_hbsv_1[c(1, 3, 4, 5, 6)]
makaskipti_2006 <- subset(data.frame(custom_aggregate(makaskipti_hbsv_1$Makaskiptasamningar, list(makaskipti_hbsv_1$Ár), sum),
                                extract_column(custom_aggregate(makaskipti_hbsv_1$Sölur, list(makaskipti_hbsv_1$Ár), sum), 'x'),
                                extract_column(custom_aggregate(makaskipti_hbsv_1$Lausafé, list(makaskipti_hbsv_1$Ár), sum), 'x')),
                                Group.1 >= 1994)
colnames(makaskipti_2006) <- c('Ár', 'Makaskipti', 'Samningar', 'Lausafé')
# Sameina gögnin. Upplýsingar um íbúðir keyptar með lausafé vantar fyrir ár fyrir 2006.
makaskipti <- rbind.fill(makaskipti, makaskipti_2006)
makaskipti$Ár <- as.integer(makaskipti$Ár)
makaskipti <- subset(data.frame(custom_aggregate(makaskipti$Makaskipti, list(makaskipti$Ár), sum),
                                extract_column(custom_aggregate(makaskipti$Samningar, list(makaskipti$Ár), sum), 'x'),
                                extract_column(aggregate(as.numeric(makaskipti$Lausafé), list(makaskipti$Ár), FUN=sum, na.rm=FALSE), 'x')),
                                Group.1 >= 1994)
colnames(makaskipti) <- c('Ár', 'Makaskipti með íbúðarhúsnæði', 'Fjöldi seldra íbúðarhúsnæða', "Fjöldi íbúðarhúsnæðis selt í lausafé")
# Eyði út millitöflum.
remove(makaskipti_2006)
remove(makaskipti_hbsv)
remove(makaskipti_hbsv_1)

########################
# Gögn yfir fjölda íbúðarhúsnæðis á landinu öllu.
# data variable: fjoldi_ibuda_allt
########################
fjoldi_ibuda_allt <- read.csv("csv/Skipting_ibuda_eftir_svfn__201508240.csv", header=TRUE, skip=2, encoding = "UTF-8")
colnames(fjoldi_ibuda_allt) <- c('Ár', 'Fjöldi íbúðarhúsnæða')

########################
# Gögn yfir fj0lda íbúðarhúsnæðis á Höfuðborgarsvæðinu.
# data variable: fjoldi_ibuda_hbsv
########################
# Gögn fyrir hvert ár er í sér skrá. Les allar inn og bý til data frame með upplýsingunum.
years <- 2014:1994
fjoldi_ibuda_hbsv <- data.frame(x=integer(21), y=integer(21), stringsAsFactors=FALSE)
for(i in 1:21){
  fjoldi_ibuda_temp <- read.csv(paste0("csv/Skipting_ibuda_eftir_svfn__20150824", i, ".csv"), header=TRUE, encoding = "UTF-8")
  # Tek höfuðborgarsvæðið sem öll sveitarfélög sem hafa númer lægra en 2000.
  # Sveitarfélög breytast eftir árum, svo ekki hægt að gera nákvæman lista.
  fjoldi_ibuda_temp <- subset(fjoldi_ibuda_temp, fjoldi_ibuda_temp$Sveitarfélagsnúmer < 2000)
  fjoldi_ibuda_hbsv$x[21 - i + 1] <- years[i]
  fjoldi_ibuda_hbsv$y[21 - i + 1] <- sum(fjoldi_ibuda_temp$Fjöldi.íbúða, na.rm=TRUE)
  remove(fjoldi_ibuda_temp)
}
colnames(fjoldi_ibuda_hbsv) <- c('Ár', 'Fjöldi íbúðarhúsnæða á HBSV.')

###################### 
# Gögn yfir söluverð á nýju íbúðarhúsnæði.
# data variable: soluverd_alls
######################
soluverd_alls <- read.csv("csv/Söluverð_á_nýjum_íbúðum_201502250.csv", header=TRUE, skip=1, encoding = "UTF-8")
# Aðeins áhuga á árum eftir 1993.
soluverd_alls <- subset(soluverd_alls, soluverd_alls$Ár >= 1994)
# Samræma krónutölur í þúsundum króna.
soluverd_alls$Kaupverð.á.fermeter <- round(soluverd_alls$Kaupverð.á.fermeter/1000.0)
# Ekki áhuga á vísítölu (er bara prósentuaukning frá upphafsári).
soluverd_alls <- soluverd_alls[, c(1, 3, 4)]
colnames(soluverd_alls) <- c("Ár", "Fermetraverð á nýju íbúðarhúsnæði [þús. kr]", "Fjöldi seldra nýrra íbúðarhúsnæða")

###################### 
# Gögn yfir söluverð á nýjum íbúðum í fjölbýli.
# data variable: soluverd_fjol
######################
# Sama aðferð og fyrir öll íbúðarhúsnæði.
soluverd_fjol <- read.csv("csv/Söluverð_á_nýjum_íbúðum_201502251.csv", header=TRUE, skip=1, encoding = "UTF-8")
soluverd_fjol <- subset(soluverd_fjol, soluverd_fjol$Ár >= 1994)
soluverd_fjol$Kaupverð.á.fermeter <- round(soluverd_fjol$Kaupverð.á.fermeter/1000.0)
soluverd_fjol <- soluverd_fjol[, c(1, 3, 4)]
colnames(soluverd_fjol) <- c("Ár", "Fermetraverð á nýjum íbúðum í fjölbýli [þús. kr]", "Fjöldi seldra nýrra íbúða í fjölbýli")

###################### 
# Gögn yfir söluverð á nýjum íbúðum í sérbýli.
# data variable: soluverd_ein
######################
# Sama aðferð og fyrir öll íbúðarhúsnæði.
soluverd_ein <- read.csv("csv/Söluverð_á_nýjum_íbúðum_201502252.csv", header=TRUE, skip=1, encoding = "UTF-8")
soluverd_ein <- subset(soluverd_ein, soluverd_ein$Ár >= 1994)
soluverd_ein$Kaupverð.á.fermeter <- round(soluverd_ein$Kaupverð.á.fermeter/1000.0)
soluverd_ein <- soluverd_ein[, c(1, 3, 4)]
colnames(soluverd_ein) <- c("Ár", "Fermetraverð á nýjum íbúðum í sérbýli [þús. kr]", "Fjöldi seldra nýrra íbúða í sérbýli")

######################
# Gögn yfir fjölda sumarhúsa á höfuðborgarsvæðinu og landinu öllu.
# data variable: sumarhus_landshlutum.
######################
sumarhus_landshlutum <- read.csv("csv/Sumarhús_e_landshlutum_24_08_20150.csv", header=TRUE, skip=2, nrows=18, encoding = "UTF-8")
# Aðeins áhuga á HBSV og öllu landinu.
sumarhus_landshlutum <- sumarhus_landshlutum[, c(1, 2, 10)]
colnames(sumarhus_landshlutum) <- c("Ár", "Fjöldi sumarhúsa á HBSV", "Fjöldi sumarhúsa")