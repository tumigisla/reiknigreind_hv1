# install.packages('pxweb')
# install.packages('data.table')
#install.packages('googleVis')

require(pxweb)
require(data.table)
require(googleVis)

#Sækjum gögn frá hagstofunni

bygging_ibudarhusnaeda <-
  subset(data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingar/IDN03001.px',
                            dims=list('Byggingarstaða'=c('*'), 'Eining'='*', 'Ár'=c('*')), clean=FALSE)), Ár >= 1994 & Ár <= 2014)

gistinaetur <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/ferdathjonusta/Gisting/GiAllir/SAM01601.px',
                            dims=list('Ríkisfang'=c('*'), 'Landsvæði'=c('1'), 'Mánuður'=c('0'), 'Eining'=c('1'), 'Ár'=c('*')), clean=FALSE))
gistinaetur$Eining <- NULL

launakostnadarvisitala <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/launakostnadarvisitala/VIN02500.px',
                            dims=list('Ársfjórðungur'=c('4'), 'Atvinnugrein'=c('*'), 'Vísitala'=c('*'), 'Eining'=c('*'), 'Ár'=c('*')), clean=FALSE))
launakostnadarvisitala$Ársfjórðungur <- NULL

visitala_kaupmattar_launa <-
  subset(data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Samfelag/launogtekjur/1_launavisitala/1_launavisitala/VIS04004.px',
                            dims=list('Breytingar'=c('*'), 'Mánuður'=c('12'), 'Ár'=c('*')), clean=FALSE))
         , Ár >= 1994 & Ár <= 2014, select=c("Ár", "Vísitala", "Árshækkun síðustu 12 mánuði, %")
        )

byggingarvisitala <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingavisitala/byggingarvisitala/VIS03001.px',
                            dims=list('Vísitala'=c('*'), 'Mánuður'=c('*'), 'Ár'=c('*')), clean=FALSE))

byggingarvisitala_agg <-
  filter_by_period(
    data.frame(custom_aggregate(byggingarvisitala$`Grunnur frá 1939`, list(byggingarvisitala$Ár), mean)
               , extract_column(custom_aggregate(byggingarvisitala$`Grunnur frá 1955`, list(byggingarvisitala$Ár), mean), "x")
               , extract_column(custom_aggregate(byggingarvisitala$`Grunnur frá 1975`, list(byggingarvisitala$Ár), mean), "x")
               , extract_column(custom_aggregate(byggingarvisitala$`Grunnur frá 1983`, list(byggingarvisitala$Ár), mean), "x")
               , extract_column(custom_aggregate(byggingarvisitala$`Grunnur frá 1987`, list(byggingarvisitala$Ár), mean), "x")
               , extract_column(custom_aggregate(byggingarvisitala$`Grunnur frá 2010`, list(byggingarvisitala$Ár), mean), "x")
    ), 1994, 2014
  )
colnames(byggingarvisitala_agg) <- c("Ár", "Grunnur frá 1939", "Grunnur frá 1955", "Grunnur frá 1975"
                                     , "Grunnur frá 1983", "Grunnur frá 1987", "Grunnur frá 2010")

skuldir_eignir_eiginfjarstada <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Efnahagur/thjodhagsreikningar/skuldastada_heimili/THJ09000.px',
                            dims=list("Fjölskyldugerð, aldur og búseta"=c('*'), "Skuldir, eignir og eiginfjárstaða"=c('*'), "Ár"=c('*')), clean=FALSE))

rummetra_og_fermetraverd <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingavisitala/byggingarvisitala/VIS03304.px',
                            dims=list('Ár'=c('*'), 'Mánuður'='*', 'Eining'=c('*')), clean=FALSE))

rummetra_og_fermetraverd_agg <- 
  filter_by_period(data.frame(custom_aggregate(rummetra_og_fermetraverd$Rúmmetraverð, list(rummetra_og_fermetraverd$Ár), mean)
                    , extract_column(custom_aggregate(rummetra_og_fermetraverd$Fermetraverð, list(rummetra_og_fermetraverd$Ár), mean), "x"))
                    , 1994, 2014)
colnames(rummetra_og_fermetraverd_agg) <- c("Ár", "Rúmmetraverð", "Fermetraverð")

fjolskyldur_med_neikvaett_eigid_fe <-
  data.table(get_pxweb_data(url='http://px.hagstofa.is/pxis/api/v1/is/Efnahagur/thjodhagsreikningar/skuldastada_heimili/THJ09008.px',
                            dims=list('Fjöldi fjölskyldna með neikvætt eigið fé í fasteign'=c('*'), 'Ár'=c('*')), clean=FALSE))
colnames(fjolskyldur_med_neikvaett_eigid_fe) <- c("Ár", "Fjöldi fjölskyldna", "Samtals (í m.kr.)", "Meðaltal(í m.kr.)")

# Hjálparföll

# xList er þau gögn sem á að aggregate-a.
# byList er sá listi sem aggregate-a á eftir.
# func er nafn á því falli sem aggregate-a á með.
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

# dataentity er t.d. data.frame eða data.table
# yearfrom er til og með því ári sem filtera á frá
# yearto er til og með því ári sem filtera á til
filter_by_period <- function(dataentity, yearfrom, yearto)
{
  return(subset(dataentity, Group.1 >= yearfrom & Group.1 <= yearto))
}

#Googlevis dót
Motion = gvisMotionChart(skuldir_eignir_eiginfjarstada, idvar="Eignir alls", timevar="Ár")
plot(Motion)




