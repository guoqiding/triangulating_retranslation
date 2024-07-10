## collecting data from pos-tagged texts

library(quanteda)
library(quanteda.textstats)
library(readtext)

fileDir <- "D:/project/gatsby/texts_pos"
files <- list.files(fileDir, full.name = T, recursive = T)

txts <- readtext(paste0(files))

txts$text <- gsub('\n', ' ', txts$text)
txts$text <- gsub('\\S+_', '_', txts$text)
txts$text <- gsub('_NR|_NT', '_NN', txts$text)
txts$text <- gsub('_VC|_VE', '_VV', txts$text)
txts$text <- gsub('_VA', '_JJ', txts$text)
txts$text <- gsub('_SB|_LB', '_BEI', txts$text)
txts$text <- gsub('_CS', '_CC', txts$text)
txts$text <- gsub('_DEG|_DEC|_DEV|_DER', '_AUX', txts$text)
txts$text <- gsub('_MSP', '_SP', txts$text)
txts$text <- gsub('_OD', '_CD', txts$text)
txts$text <- gsub('_', '', txts$text)

toks <- tokens(txts$text, what = "fasterword")
tok_count <- ntoken(toks)

tdfm <- dfm(toks)
tdf <- convert(tdfm, to="data.frame")
tdf <- tdf[,-1]

dat <- cbind(id=gsub('.*/(.+?)/.+?.txt','\\1',files), id2=gsub('.txt','',txts$doc_id), tok_count, tdf)
dat$pu <- dat$pu / dat$tok_count * 100
dat$wc <- dat$tok_count - dat$pu
dat$cont <- dat$nn + dat$vv + dat$jj + dat$ad
dat$n2v <- (dat$nn + dat$jj + dat$p) / (dat$vv + dat$ad +  dat$cc)
dat$v2j <- dat$vv / (dat$vv + dat$jj)

dat2 <- dat[,c('wc','nn','vv','jj','ad','cont','pn','p','cc','ba','bei')]
dat2 <- dat2/dat2$wc * 100
colnames(dat2) <- gsub('\\bp\\b','pp',colnames(dat2))

my_dat <- cbind(dat[,c('id','id2','pu','n2v','v2j')], dat2[,-1])

write.csv(my_dat, 'D:/project/gatsby/results/data_13_features.csv', row.names=F)
