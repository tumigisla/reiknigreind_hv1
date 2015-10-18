# install.packages('pxweb')
# install.packages('data.table')
# install.packages('googleVis')

require(pxweb)
require(data.table)
require(googleVis)

# Hjálparföll

# xList er þau gögn sem á að aggregate-a.
# byList er sá listi sem aggregate-a á eftir.
# func er nafn á því falli sem aggregate-a á með.
custom_aggregate <- function(xList, byList, func)
{
  return(aggregate(numerify_list(xList)
                   ,by=byList, FUN=func, na.rm=TRUE, na.naction=NULL))
}

# list er listi af strengjum eða tölum
numerify_list <- function(list)
{
  return(as.numeric(lapply(list, function(x) {replace(x, is.na(x) | x == '.', 0)})))
}

# dataentity er t.d. data.frame eða data.table
# columnname er nafn þess dálks sem við viljum einangra úr dataentity
extract_column <- function(dataentity, columnname)
{
  return(subset(dataentity, select=c(columnname)))
}

# dataentity er t.d. data.frame eða data.table
# yearfrom er til og með því ári sem filtera á frá
# yearto er til og með því ári sem filtera á til
filter_by_period <- function(dataentity, yearfrom, yearto)
{
  return(subset(dataentity, Group.1 >= yearfrom & Group.1 <= yearto))
}

#Sækjum gögn frá hagstofunni

#################
# Bygging íbúðarhúsnæða
# Data variable: bygging_ibudarhusnaeda
#################
bygging_ibudarhusnaeda <-
  subset(data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingar/IDN03001.px',
                            dims=list('Byggingarstaða'=c('1', '2'), 'Eining'=c('*'), 'Ár'=c('*')), clean=FALSE)), Ár >= 1994 & Ár <= 2014)

# Bæti við hbsv (Höfuðborgarsvæðið) í dálkaheiti
bygging_ibudarhusnaeda_dalkanofn <- NULL
colnames(bygging_ibudarhusnaeda) <- c('Ár', 'Fjöldi íbúðahúsnæða í byggingu á HBSV.', 'Fermetrar af íbúðahúsnæði í byggingu á HBSV. [þús. m\U00B2]', 'Fjöldi nýbyggða íbúðahúsnæða á HBSV.',
                                      'Fermetrar af nýbyggðu íbúðarhúsnæði á HBSV. [þús. m\U00B2]')

#################
# Gistinætur
# Data variable: gistinaetur_modified
#################
gistinaetur <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/ferdathjonusta/Gisting/GiAllir/SAM01601.px',
                            dims=list('Ríkisfang'=c('0', '1', '2'), 'Landsvæði'=c('1'), 'Mánuður'=c('0'), 'Eining'=c('1'), 'Ár'=c('*')), clean=FALSE))

# Tek út dálk sem á ekki við
gistinaetur$Eining <- NULL

# Læt línurnar úr gamla vera dálka í nýju, breyttu data frame-i
gistinaetur_modified <- c(1998:2014)
fjoldi_rikisfanga <- length(gistinaetur$Ríkisfang)
for (i in 1:fjoldi_rikisfanga)
{
  stakt_rikisfang <- subset(gistinaetur, gistinaetur$Ríkisfang == gistinaetur$Ríkisfang[[i]])
  gistinaetur_rikisfangs <- NULL
  for (gistinott in stakt_rikisfang)
  {
    gistinaetur_rikisfangs <- c(gistinaetur_rikisfangs, gistinott) 
  }
  gistinaetur_modified <- cbind(data.frame(gistinaetur_modified, rev(gistinaetur_rikisfangs[-1])))
}

# Bæti við hbsv(Höfuðborgarsvæðið) o.fl. uppl. í dálkaheiti
gistinaetur_dalkanofn <- NULL
for (rikisfang in c('Allir', 'Íslendingar', 'Útlendingar'))
{
  gistinaetur_dalkanofn <- c(gistinaetur_dalkanofn, paste0("Fjöldi Gistinátta á HBSV, ", rikisfang))
}
colnames(gistinaetur_modified) <- c("Ár", gistinaetur_dalkanofn)
remove(gistinaetur)

#################
# Launakostnaðarvísitala
# Data variable: launakostnadarvisitala
#################
launakostnadarvisitala <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/launakostnadur/launakostnadureldra/VIN02500.px',
                           dims=list('Ársfjórðungur'=c('4'), 'Atvinnugrein'=c('*'), 'Vísitala'=c('2'), 'Eining'=c('0'), 'Ár'=c('*')), clean=FALSE))
# Tek út dálk sem á ekki við
launakostnadarvisitala$Ársfjórðungur <- NULL
colnames(launakostnadarvisitala) <- 
  c("Ár", "Vísitala heildarlauna í iðnaði", "Vísitala heildarlauna í byggingarstarfsemi og mannvirkjagerð",
    "Vísitala heildarlauna í verslun og viðgerðarþjónustu", "Vísitala heildarlauna í samgöngum og flutningum")

# Sjáum að 2013 vantar alveg, tökum það út
launakostnadarvisitala <- subset(launakostnadarvisitala, Ár < 2013)

#################
# Vísitala kaupmáttar launa
# Data variable: visitala_kaupmattar_launa
#################
visitala_kaupmattar_launa <-
  subset(data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Samfelag/launogtekjur/1_launavisitala/1_launavisitala/VIS04004.px',
                            dims=list('Breytingar'=c('*'), 'Mánuður'=c('12'), 'Ár'=c('*')), clean=FALSE))
         , Ár >= 1994 & Ár <= 2014, select=c("Ár", "Vísitala", "Árshækkun síðustu 12 mánuði, %")
        )
colnames(visitala_kaupmattar_launa) <- c("Ár", "Vísitala kaupmáttar launa", "Árshækkun vísitölu kaupmáttar launa síðustu 12 mánuði, %")
visitala_kaupmattar_launa$`Árshækkun vísitölu kaupmáttar launa síðustu 12 mánuði, %` <- NULL

#################
# Byggingarvísitala
# Data variable: byggingarvisitala_agg
#################
byggingarvisitala <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingavisitala/byggingarvisitala/VIS03001.px',
                            dims=list('Vísitala'=c('*'), 'Mánuður'=c('*'), 'Ár'=c('*')), clean=FALSE))

# Set meðaltal hvers árs inn í  nýtt data frame
byggingarvisitala_agg <-
  filter_by_period(
    data.frame(custom_aggregate(byggingarvisitala$`Grunnur frá 1955`, list(byggingarvisitala$Ár), mean)
               , extract_column(custom_aggregate(byggingarvisitala$`Grunnur frá 1975`, list(byggingarvisitala$Ár), mean), "x")
               , extract_column(custom_aggregate(byggingarvisitala$`Grunnur frá 1983`, list(byggingarvisitala$Ár), mean), "x")
               , extract_column(custom_aggregate(byggingarvisitala$`Grunnur frá 1987`, list(byggingarvisitala$Ár), mean), "x")
               , extract_column(custom_aggregate(byggingarvisitala$`Grunnur frá 2010`, list(byggingarvisitala$Ár), mean), "x")
    ), 1994, 2014
  )
remove(byggingarvisitala)
byggingarvisitala_agg$`Byggingarvísitala, grunnur frá 1939` <- NULL
colnames(byggingarvisitala_agg) <- c("Ár", "Byggingarvísitala, grunnur frá 1955"
                                     , "Byggingarvísitala, grunnur frá 1975", "Byggingarvísitala, grunnur frá 1983
                                     ", "Byggingarvísitala", "Byggingarvísitala, grunnur frá 2010")
byggingarvisitala_agg <- byggingarvisitala_agg[c(1,5)]

#################
# Skuldir, eignir og eiginfjárstaða heimila
# Data variable: skuldir_eignir_eiginfjarstada
#################
skuldir_eignir_eiginfjarstada <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Efnahagur/thjodhagsreikningar/skuldastada_heimili/THJ09000.px',
                            dims=list("Fjölskyldugerð, aldur og búseta"=c('15'), "Skuldir, eignir og eiginfjárstaða"=c('*'), "Ár"=c('*')), clean=FALSE))

# Tek út dálka sem eiga ekki við
skuldir_eignir_eiginfjarstada$`Fjölskyldugerð, aldur og búseta` <- NULL
skuldastada_heimila_dalkanofn <- NULL

# Bæti inn hbsv (Höfuðborgarsvæðið) og þús.kr í dálkaheiti
for (dalkur in colnames(skuldir_eignir_eiginfjarstada))
{
  nytt_dalkanafn <- dalkur 
  if (dalkur != "Ár")
    nytt_dalkanafn <- paste0("Heimili hbsv. ", nytt_dalkanafn, " [þús.kr]")
  skuldastada_heimila_dalkanofn <- c(skuldastada_heimila_dalkanofn, nytt_dalkanafn)
}
colnames(skuldir_eignir_eiginfjarstada) <- skuldastada_heimila_dalkanofn

# Margfalda öll gildin með 1000 tþa tölurnar séu í þús.kr
for (i in 1:(length(colnames(skuldir_eignir_eiginfjarstada)) - 1))
{
  skuldir_eignir_eiginfjarstada[[i + 1]] <- round(skuldir_eignir_eiginfjarstada[[i + 1]] * 1000.0)  
}

#################
# Rúmmetra og fermetraverð í byggingarvísitöluhúsi
# Data variable: rummetra_og_fermetraverd_agg
#################
rummetra_og_fermetraverd <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingavisitala/byggingarvisitala/VIS03304.px',
                            dims=list('Ár'=c('*'), 'Mánuður'='*', 'Eining'=c('*')), clean=FALSE))

# Set meðaltal hvers árs inn í nýtt data frame
rummetra_og_fermetraverd_agg <- 
  filter_by_period(data.frame(custom_aggregate(rummetra_og_fermetraverd$Rúmmetraverð, list(rummetra_og_fermetraverd$Ár), mean)
                    , extract_column(custom_aggregate(rummetra_og_fermetraverd$Fermetraverð, list(rummetra_og_fermetraverd$Ár), mean), "x"))
                    , 1994, 2014)

# Deili öllum gildum með 1000 tþa tölurnar séu í þús.kr
colnames(rummetra_og_fermetraverd_agg) <- c("Ár", "Rúmmetraverð á vísítöluhúsi á HBSV. [þús.kr]", "Fermetraverð á vísitöluhúsi á HBSV. [þús.kr]")
rummetra_og_fermetraverd_agg$`Rúmmetraverð á vísítöluhúsi á HBSV. [þús.kr]` <- round(rummetra_og_fermetraverd_agg$`Rúmmetraverð á vísítöluhúsi á HBSV. [þús.kr]` / 1000.0)
rummetra_og_fermetraverd_agg$`Fermetraverð á vísitöluhúsi á HBSV. [þús.kr]` <- round(rummetra_og_fermetraverd_agg$`Fermetraverð á vísitöluhúsi á HBSV. [þús.kr]` / 1000.0)
remove(rummetra_og_fermetraverd)

#################
# Fjölskyldur með neikvætt eigið fé
# Data variable: fjolskyldur_med_neikvaett_eigid_fe
#################
fjolskyldur_med_neikvaett_eigid_fe <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Efnahagur/thjodhagsreikningar/skuldastada_heimili/THJ09008.px',
                            dims=list('Fjöldi fjölskyldna með neikvætt eigið fé í fasteign'=c('*'), 'Ár'=c('*')), clean=FALSE))

# Margfalda öll gildi með 1000 tþa tölurnar séu í þús.kr
colnames(fjolskyldur_med_neikvaett_eigid_fe) <-
  c("Ár", "Fjöldi fjölskyldna með neikvætt eigið fé", "Neikvætt eigið fé fjölskyldna, samtals [þús.kr]", "Neikvætt eigið fé fjölskyldna, meðaltal [þús.kr]")
fjolskyldur_med_neikvaett_eigid_fe$`Neikvætt eigið fé fjölskyldna, samtals [þús.kr]` <- NULL

fjolskyldur_med_neikvaett_eigid_fe$`Neikvætt eigið fé fjölskyldna, meðaltal [þús.kr]` <- 
  abs(round(fjolskyldur_med_neikvaett_eigid_fe$`Neikvætt eigið fé fjölskyldna, meðaltal [þús.kr]` * 1000.0))

#Data frame merging
masterFrame <- data.frame(Reduce(function(x, y) merge(x, y, all=TRUE, by='Ár'), 
                                 list(byggingarvisitala_agg,
                                      bygging_ibudarhusnaeda,
                                      fjoldi_ibuda_allt,
                                      fjolskyldur_med_neikvaett_eigid_fe,
                                      skuldir_eignir_eiginfjarstada,
                                      gistinaetur_modified,
                                      makaskipti,
                                      rummetra_og_fermetraverd_agg,
                                      hbsv_eftir_ar_all,
                                      hbsv_eftir_ar_ein,
                                      hbsv_eftir_ar_fjol,
                                      soluverd_alls,
                                      soluverd_ein,
                                      soluverd_fjol,
                                      sumarhus_landshlutum,
                                      visitala_kaupmattar_launa,
                                      launakostnadarvisitala
                                 )), check.names = FALSE)
                      
for(i in c(1,3:ncol(masterFrame))) {
  masterFrame[,i] <- as.numeric(as.character(masterFrame[,i]))
}

masterFrameScatter <- masterFrame[sapply(masterFrame, function(masterFrame) !any(is.na(masterFrame)))] 
masterFrameScatter[] <- lapply(masterFrameScatter, function(x) as.numeric(as.character(x)))

# Hefur 0 í staðinn fyrir öll NA
masterFrame_wo_NAs <- masterFrame
for(i in c(1,3:ncol(masterFrame_wo_NAs))) {
  masterFrame_wo_NAs[,i] <- suppressWarnings(as.numeric(as.character(masterFrame_wo_NAs[,i])))
}
for (i in 1:(length(masterFrame_wo_NAs) - 1))
{
  masterFrame_wo_NAs[[i + 1]] <- lapply(masterFrame_wo_NAs[[i + 1]], function(x) {replace(x, is.na(x) | x == 'NA' | x == '.' | x == '..', -2147483647)})
} 