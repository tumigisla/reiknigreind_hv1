install.packages("shiny")
install.packages('pxweb') 
install.packages('googleVis') 

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

#Googlevis dót

head(skuldir_eignir_eiginfjarstada)
summary(skuldir_eignir_eiginfjarstada)

Motion = gvisMotionChart(skuldir_eignir_eiginfjarstada, idvar="Eignir alls", timevar="Ár")
plot(Motion)

help('gvisMotionChart')

