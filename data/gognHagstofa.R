# install.packages('pxweb')
# install.packages('data.table')
# install.packages('googleVis')

require(pxweb)
require(data.table)
require(googleVis)

#Sækjum gögn frá hagstofunni

bygging_ibudarhusnaeda <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingar/IDN03001.px',
                            dims=list('Byggingarstaða'=c('*'), 'Eining'='*', 'Ár'=c('*')), clean=FALSE))

gistinaetur <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/ferdathjonusta/Gisting/GiAllir/SAM01601.px',
                            dims=list('Ríkisfang'=c('*'), 'Landsvæði'=c('*'), 'Mánuður'=c('*'), 'Eining'='*', 'Ár'=c('*')), clean=FALSE))

launakostnadarvisitala <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/launakostnadarvisitala/VIN02500.px',
                            dims=list('Ársfjórðungur'=c('*'), 'Atvinnugrein'=c('*'), 'Vísitala'=c('*'), 'Eining'='*', 'Ár'=c('*')), clean=FALSE))

visitala_kaupmattar_launa <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Samfelag/launogtekjur/1_launavisitala/1_launavisitala/VIS04004.px',
                            dims=list('Breytingar'=c('*'), 'Mánuður'=c('*'), 'Ár'=c('*')), clean=FALSE))

byggingarvisitala <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingavisitala/byggingarvisitala/VIS03001.px',
                            dims=list('Vísitala'=c('*'), 'Mánuður'=c('*'), 'Ár'=c('*')), clean=FALSE))

skuldir_eignir_eiginfjarstada <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Efnahagur/thjodhagsreikningar/skuldastada_heimili/THJ09000.px',
                            dims=list("Fjölskyldugerð, aldur og búseta"=c('*'), "Skuldir, eignir og eiginfjárstaða"=c('*'), "Ár"=c('*')), clean=FALSE))

rummetra_og_fermetraverd <- 
    subset(data.frame(custom_mean_aggregate(rummetra_og_fermetraverd$Rúmmetraverð, list(rummetra_og_fermetraverd$Ár))
                      , extract_column(custom_mean_aggregate(rummetra_og_fermetraverd$Fermetraverð, list(rummetra_og_fermetraverd$Ár)), "x"))
                      , Group.1 > 1994 & Group.1 < 2015)
colnames(rummetra_og_fermetraverd_agg) <- c("Ár", "Rúmmetraverð", "Fermetraverð")

fjolskyldur_med_neikvaett_eigid_fe <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Efnahagur/thjodhagsreikningar/skuldastada_heimili/THJ09008.px',
                            dims=list('Fjöldi fjölskyldna með neikvætt eigið fé í fasteign'=c('*'), 'Ár'=c('*')), clean=FALSE))

# Hjálparföll

# xList er þau gögn sem á að aggregate-a.
# byList er sá listi sem aggregate-a á eftir.
custom_mean_aggregate <- function(xList, byList)
{
  return(aggregate(as.numeric(lapply(xList, function (x) {replace(x, is.na(x) | x == '.', 0)}))
                   ,by=byList, FUN=mean, na.rm=TRUE, na.naction=NULL))
}

# dataentity er t.d. data.frame eða data.table
# columnname er nafn þess dálks sem við viljum einangra úr dataentity
extract_column <- function(dataentity, columnname)
{
  return(subset(dataentity, select=c(columnname)))
}

#Googlevis dót

head(skuldir_eignir_eiginfjarstada)
summary(skuldir_eignir_eiginfjarstada)

Motion = gvisMotionChart(skuldir_eignir_eiginfjarstada, idvar="Eignir alls", timevar="Ár")
plot(Motion)

help('gvisMotionChart')

