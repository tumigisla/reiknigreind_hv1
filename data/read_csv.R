#Interesting
leiguverd <- read.csv('csv/arid2014leiguverd_260220150.csv', header=TRUE, skip=3, dec=',', as.is=TRUE)
# Taka saman m�nu�i:
makaskipti_hbsv <- read.csv('csv/fjoldi_makaskipta_ibudir_hbsv_1993-2006_eftir_kaupdegi0.csv', header = TRUE, dec=',', as.is=TRUE)
# Ver� eftir �ri.
hbsv_eftir_ar_all <- read.csv("csv/hbsv_eftir_�r_allt_saman_201502260.csv", header = TRUE, skip=1, nrows=34)
hbsv_eftir_ar_fjol <- read.csv("csv/hbsv_eftir_�r_allt_saman_201502261.csv", header = TRUE, skip=1, nrows = 34)
hbsv_eftir_ar_ein <- read.csv("csv/hbsv_eftir_�r_allt_saman_201502262.csv", header = TRUE, skip=1, nrows=34)
# Uppl�singar um ver� eftir landshlutum.
landshlutar <- read.csv("csv/Landshlutar_201502250.csv", header=TRUE, skip=1)
# Makaskipti
makaskipti_hbsv_1 <- read.csv("csv/Makaskipti_hbsv_201502250.csv", header=TRUE, skip=1)
makaskipti_utan <- read.csv("csv/Makaskipti_utan_hbsv_201502250.csv", header=TRUE, skip=1)
# Fj�ldi �b��a allt land.
fjoldi_ibuda <- read.csv("csv/Skipting_ibuda_eftir_svfn__201508240.csv", header=TRUE, skip=1)
# Fjoldi ibu�a eftir sveitarfelagi.
fjoldi_ibuda_2014 <- read.csv("csv/Skipting_ibuda_eftir_svfn__201508241.csv", header=TRUE)
fjoldi_ibuda_2013 <- read.csv("csv/Skipting_ibuda_eftir_svfn__201508242.csv", header=TRUE)
fjoldi_ibuda_2012 <- read.csv("csv/Skipting_ibuda_eftir_svfn__201508243.csv", header=TRUE)
fjoldi_ibuda_2011 <- read.csv("csv/Skipting_ibuda_eftir_svfn__201508244.csv", header=TRUE)
fjoldi_ibuda_2010 <- read.csv("csv/Skipting_ibuda_eftir_svfn__201508245.csv", header=TRUE)
fjoldi_ibuda_2009 <- read.csv("csv/Skipting_ibuda_eftir_svfn__201508246.csv", header=TRUE)
fjoldi_ibuda_2008 <- read.csv("csv/Skipting_ibuda_eftir_svfn__201508247.csv", header=TRUE)
fjoldi_ibuda_2007 <- read.csv("csv/Skipting_ibuda_eftir_svfn__201508248.csv", header=TRUE)
fjoldi_ibuda_2006 <- read.csv("csv/Skipting_ibuda_eftir_svfn__201508249.csv", header=TRUE)
fjoldi_ibuda_2005 <- read.csv("csv/Skipting_ibuda_eftir_svfn__2015082410.csv", header=TRUE)
fjoldi_ibuda_2004 <- read.csv("csv/Skipting_ibuda_eftir_svfn__2015082411.csv", header=TRUE)
fjoldi_ibuda_2003 <- read.csv("csv/Skipting_ibuda_eftir_svfn__2015082412.csv", header=TRUE)
fjoldi_ibuda_2002 <- read.csv("csv/Skipting_ibuda_eftir_svfn__2015082413.csv", header=TRUE)
fjoldi_ibuda_2001 <- read.csv("csv/Skipting_ibuda_eftir_svfn__2015082414.csv", header=TRUE)
fjoldi_ibuda_2000 <- read.csv("csv/Skipting_ibuda_eftir_svfn__2015082415.csv", header=TRUE)
fjoldi_ibuda_1999 <- read.csv("csv/Skipting_ibuda_eftir_svfn__2015082416.csv", header=TRUE)
fjoldi_ibuda_1998 <- read.csv("csv/Skipting_ibuda_eftir_svfn__2015082417.csv", header=TRUE)
fjoldi_ibuda_1997 <- read.csv("csv/Skipting_ibuda_eftir_svfn__2015082418.csv", header=TRUE)
fjoldi_ibuda_1996 <- read.csv("csv/Skipting_ibuda_eftir_svfn__2015082419.csv", header=TRUE)
fjoldi_ibuda_1995 <- read.csv("csv/Skipting_ibuda_eftir_svfn__2015082420.csv", header=TRUE)
fjoldi_ibuda_1994 <- read.csv("csv/Skipting_ibuda_eftir_svfn__2015082421.csv", header=TRUE)
# Skipting eftir ger�um.
fjoldi_ibuda_gerd_2014 <- read.csv("csv/Skipting_ibuda_eftir_svfn_og_gerd_201508240.csv", header=TRUE, skip=1)
fjoldi_ibuda_gerd_2013 <- read.csv("csv/Skipting_ibuda_eftir_svfn_og_gerd_201508241.csv", header=TRUE, skip=1)
fjoldi_ibuda_gerd_2012 <- read.csv("csv/Skipting_ibuda_eftir_svfn_og_gerd_201508242.csv", header=TRUE, skip=1)
fjoldi_ibuda_gerd_2011 <- read.csv("csv/Skipting_ibuda_eftir_svfn_og_gerd_201508243.csv", header=TRUE, skip=1)
# S�luver�
soluverd_alls <- read.csv("csv/S�luver�_�_n�jum_�b��um_201502250.csv", header=TRUE, skip=1)
soluverd_fjol <- read.csv("csv/S�luver�_�_n�jum_�b��um_201502251.csv", header=TRUE, skip=1)
soluverd_ein <- read.csv("csv/S�luver�_�_n�jum_�b��um_201502252.csv", header=TRUE, skip=1)
# Fj�ldi sumarh�sa.
sumarhus_landshlutum <- read.csv("csv/Sumarh�s_e_landshlutum_24_08_20150.csv", header=TRUE, skip=2, nrows=18)
# Ver� eftir b�jarf�lagi
verd_baer <- read.csv("csv/verd_eftir_b�jum_fr�19900.csv", header=TRUE, skip=1)