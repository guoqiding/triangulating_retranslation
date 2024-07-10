library(quanteda)
library(quanteda.textstats)
library(readtext)
library(dplyr)

dict1 <- readLines("D:/project/gatsby/wordlists/sinica_common.txt")
dict2 <- read.csv("D:/project/gatsby/wordlists/sinica.csv")
dict3 <- read.csv("D:/project/gatsby/wordlists/idioms.csv")

fileDir <- "D:/project/gatsby/texts"
files <- list.files(fileDir, full.name = T, recursive = T)

txts <- readtext(paste0(files))

toks <- tokens(txts$text, what = "fasterword", remove_punct = TRUE)
wc <- ntoken(toks)

# Calculating the KTTR
tdfm <- dfm(toks)
kttr <- textstat_lexdiv(tdfm, "K")
dat <- cbind(gsub('.*/(.+?)/.+?.txt','\\1',files), gsub('.txt','',txts$doc_id), wc, kttr[,2])
colnames(dat) <- c('id', 'id2', 'wc', 'kttr')

# Hapax Richness
# hapaxes per document - applying the square root of tokens as in the manner of KTTR
hapax <- rowSums(tdfm==1) / sqrt(ntoken(tdfm))
dat <- cbind(dat, hapax)
colnames(dat)[ncol(dat)] <- 'hapax'

# Calculate the ratios of common and rare words (fasterword)
cwdict <- dictionary(list(cw = dict1))
c_dfm <- dfm_lookup(tdfm, dictionary = cwdict)
c_dat <- convert(c_dfm, to="data.frame")
cw <- c_dat$cw / wc * 100

rwdict <- dictionary(list(nrw = dict2$word))
r_dfm <- dfm_lookup(tdfm, dictionary = rwdict)
r_dat <- convert(r_dfm, to="data.frame")
rw <- (1 - r_dat$nrw / wc) * 100
dat <- cbind(dat, cw, rw)

# Calculate mean word rank
tdf <- convert(t(tdfm), to="data.frame")
tdf <- left_join(tdf, dict2[,c(1,3)], by = c('doc_id' = 'word'))
tdf <- tdf[!is.na(tdf$rank),]
tdf$doc_id <- NULL
tdf2 <- tdf[,1:nrow(tdfm)] * tdf$rank
rank <- colSums(tdf2)/colSums(tdf[,1:nrow(tdfm)])
dat <- cbind(dat, rank)

# Calculate the ratio of idioms
idict <- dictionary(list(idm = dict3$idiom))
i_dfm <- dfm_lookup(tdfm, dictionary = idict)
i_dat <- convert(i_dfm, to="data.frame")
idm <- i_dat$idm / wc * 100
dat <- cbind(dat, idm)

# Calculate average sentence length
asl <- wc/ntoken(gsub("([^[:punct:]]+)[\r\n]+","\\1。",txts$text), what="sentence")
dat <- cbind(dat, asl)
colnames(dat)[ncol(dat)] <- 'asl'

write.csv(dat, "D:/project/gatsby/results/data_7_features.csv", row.names=F, quote=F)
