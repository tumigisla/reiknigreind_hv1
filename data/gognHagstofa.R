# install.packages('pxweb')
# install.packages('data.table')
# install.packages('googleVis')

require(pxweb)
require(data.table)
require(googleVis)

#SÃ¦kjum gÃ¶gn frÃ¡ hagstofunni

bygging_ibudarhusnaeda <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingar/IDN03001.px',
                            dims=list('ByggingarstaÃ°a'=c('*'), 'Eining'='*', 'Ãr'=c('*')), clean=FALSE))

gistinaetur <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/ferdathjonusta/Gisting/GiAllir/SAM01601.px',
                            dims=list('RÃ­kisfang'=c('*'), 'LandsvÃ¦Ã°i'=c('*'), 'MÃ¡nuÃ°ur'=c('*'), 'Eining'='*', 'Ãr'=c('*')), clean=FALSE))

launakostnadarvisitala <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/launakostnadarvisitala/VIN02500.px',
                            dims=list('ÃrsfjÃ³rÃ°ungur'=c('*'), 'Atvinnugrein'=c('*'), 'VÃ­sitala'=c('*'), 'Eining'='*', 'Ãr'=c('*')), clean=FALSE))

visitala_kaupmattar_launa <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Samfelag/launogtekjur/1_launavisitala/1_launavisitala/VIS04004.px',
                            dims=list('Breytingar'=c('*'), 'MÃ¡nuÃ°ur'=c('*'), 'Ãr'=c('*')), clean=FALSE))

byggingarvisitala <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingavisitala/byggingarvisitala/VIS03001.px',
                            dims=list('VÃ­sitala'=c('*'), 'MÃ¡nuÃ°ur'=c('*'), 'Ãr'=c('*')), clean=FALSE))

skuldir_eignir_eiginfjarstada <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Efnahagur/thjodhagsreikningar/skuldastada_heimili/THJ09000.px',
                            dims=list("FjÃ¶lskyldugerÃ°, aldur og bÃºseta"=c('*'), "Skuldir, eignir og eiginfjÃ¡rstaÃ°a"=c('*'), "Ãr"=c('*')), clean=FALSE))

rummetra_og_fermetraverd <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingavisitala/byggingarvisitala/VIS03304.px',
                            dims=list('Ãr'=c('*'), 'MÃ¡nuÃ°ur'='*', 'Eining'=c('*')), clean=FALSE))

fermetraverd_agg <- aggregate(as.numeric(lapply(rummetra_og_fermetraverd$FermetraverÃ°, function (x) {replace(x, is.na(x) | x == '.', 0)}))
                              ,by=list(rummetra_og_fermetraverd$Ãr)
                              , FUN=mean, na.rm=TRUE, na.naction=NULL)
fermetraverd_agg$x[1] <- (fermetraverd_agg$x[1] / 6) * 12 # Bara til gÃ¶gn fyrir seinni hluta 1987
fermetraverd_agg$x[29] <- (fermetraverd_agg$x[29] / 9) * 12 # Vantar gÃ¶gn fyrir sÃ­Ã°ustu 3 mÃ¡nuÃ°i 2015

rummetraverd_agg <- aggregate(as.numeric(lapply(rummetra_og_fermetraverd$RÃºmmetraverÃ°, function (x) {replace(x, is.na(x) | x == '.', 0)}))
                              ,by=list(rummetra_og_fermetraverd$Ãr)
                              , FUN=mean, na.rm=TRUE, na.naction=NULL)
rummetraverd_agg$x[1] <- (rummetraverd_agg$x[1] / 6) * 12 # Bara til gÃ¶gn fyrir seinni hluta 1987
rummetraverd_agg$x[29] <- (rummetraverd_agg$x[29] / 9) * 12 # Vantar gÃ¶gn fyrir sÃ­Ã°ustu 3 mÃ¡nuÃ°i 2015

fjolskyldur_med_neikvaett_eigid_fe <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Efnahagur/thjodhagsreikningar/skuldastada_heimili/THJ09008.px',
                            dims=list('FjÃ¶ldi fjÃ¶lskyldna meÃ° neikvÃ¦tt eigiÃ° fÃ© Ã­ fasteign'=c('*'), 'Ãr'=c('*')), clean=FALSE))


#Googlevis dÃ³t

head(skuldir_eignir_eiginfjarstada)
summary(skuldir_eignir_eiginfjarstada)

Motion = gvisMotionChart(skuldir_eignir_eiginfjarstada, idvar="Eignir alls", timevar="Ãr")
plot(Motion)

help('gvisMotionChart')

