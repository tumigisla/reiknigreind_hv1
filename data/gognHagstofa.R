install.packages("shiny")
install.packages('pxweb') 

require(pxweb)
require(data.table)

bygging_ibudarhusnaeda <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingar/IDN03001.px',
                            dims=list('Byggingarstağa'=c('*'), 'Eining'='*', 'Ár'=c('*')), clean=FALSE))

gistinaetur <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/ferdathjonusta/Gisting/GiAllir/SAM01601.px',
                            dims=list('Ríkisfang'=c('*'), 'Landsvæği'=c('*'), 'Mánuğur'=c('*'), 'Eining'='*', 'Ár'=c('*')), clean=FALSE))

launakostnadarvisitala <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/launakostnadarvisitala/VIN02500.px',
                            dims=list('Ársfjórğungur'=c('*'), 'Atvinnugrein'=c('*'), 'Vísitala'=c('*'), 'Eining'='*', 'Ár'=c('*')), clean=FALSE))

visitala_kaupmattar_launa <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Samfelag/launogtekjur/1_launavisitala/1_launavisitala/VIS04004.px',
                            dims=list('Breytingar'=c('*'), 'Mánuğur'=c('*'), 'Ár'=c('*')), clean=FALSE))

byggingarvisitala <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingavisitala/byggingarvisitala/VIS03001.px',
                            dims=list('Vísitala'=c('*'), 'Mánuğur'=c('*'), 'Ár'=c('*')), clean=FALSE))

skuldir_eignir_eiginfjarstada <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Efnahagur/thjodhagsreikningar/skuldastada_heimili/THJ09000.px',
                            dims=list("Fjölskyldugerğ, aldur og búseta"=c('*'), "Skuldir, eignir og eiginfjárstağa"=c('*'), "Ár"=c('*')), clean=FALSE))





