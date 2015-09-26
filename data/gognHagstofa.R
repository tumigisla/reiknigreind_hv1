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
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingavisitala/byggingarvisitala/VIS03304.px',
                            dims=list('Ár'=c('*'), 'Mánuður'='*', 'Eining'=c('*')), clean=FALSE))

fermetraverd_agg <- aggregate(as.numeric(lapply(rummetra_og_fermetraverd$Fermetraverð, function (x) {replace(x, is.na(x) | x == '.', 0)}))
                              ,by=list(rummetra_og_fermetraverd$Ár)
                              , FUN=mean, na.rm=TRUE, na.naction=NULL)
fermetraverd_agg$x[1] <- (fermetraverd_agg$x[1] / 6) * 12 # Bara til gögn fyrir seinni hluta 1987
fermetraverd_agg$x[29] <- (fermetraverd_agg$x[29] / 9) * 12 # Vantar gögn fyrir síðustu 3 mánuði 2015

rummetraverd_agg <- aggregate(as.numeric(lapply(rummetra_og_fermetraverd$Rúmmetraverð, function (x) {replace(x, is.na(x) | x == '.', 0)}))
                              ,by=list(rummetra_og_fermetraverd$Ár)
                              , FUN=mean, na.rm=TRUE, na.naction=NULL)
rummetraverd_agg$x[1] <- (rummetraverd_agg$x[1] / 6) * 12 # Bara til gögn fyrir seinni hluta 1987
rummetraverd_agg$x[29] <- (rummetraverd_agg$x[29] / 9) * 12 # Vantar gögn fyrir síðustu 3 mánuði 2015

fjolskyldur_med_neikvaett_eigid_fe <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Efnahagur/thjodhagsreikningar/skuldastada_heimili/THJ09008.px',
                            dims=list('Fjöldi fjölskyldna með neikvætt eigið fé í fasteign'=c('*'), 'Ár'=c('*')), clean=FALSE))


#Googlevis dót

head(skuldir_eignir_eiginfjarstada)
summary(skuldir_eignir_eiginfjarstada)

Motion = gvisMotionChart(skuldir_eignir_eiginfjarstada, idvar="Eignir alls", timevar="Ár")
plot(Motion)

help('gvisMotionChart')

