# calculate sentence sentiment using sentimentr
# for English texts, the original codes are used

library(readtext)
library(sentimentr)

texts <- readtext(paste0("D:/project/gatsby/texts/eng/*.txt"))
sentences <- get_sentences(texts)
sent <- sentiment(sentences)
sent <- sent[!is.na(sent$word_count),]
write.csv(sent[,c(3,4,6)], 'D:/project/gatsby/data/sentiment_data/eng.csv', row.names=F)


# for Chinese texts, both the codes and the lexicons have to be revised

source('D:/project/gatsby/codes/7-functions.R', echo=F)
source('D:/project/gatsby/codes/7-sentimentz2.R', echo=F, encoding='UTF-8')

# load the lexicons
lexicons <- read.csv("D:/project/gatsby/wordlists/sentiment_dalian_taiwan.csv",header=T,as.is=T)
shifters <- read.csv("D:/project/gatsby/wordlists/sentiment_shifters.csv",header=T,as.is=T)

lexicons <- lexicons[!lexicons$x %in% shifters$x,]

polarity_cn <- as_key(lexicons)
shifters_cn <- as_key(shifters)

polarity_cn[polarity_cn$y<0,]$y <- polarity_cn[polarity_cn$y<0,]$y * 1.5

# input the directory containing texts
dir <- "D:/project/gatsby/texts_seg/chang"
list <- list.files(dir)

sent_data <- data.frame()

for (i in list) {

texts <- readtext(paste0(dir, '/', i))

sent_df <- sentimentz(texts$text, polarity_dt = polarity_cn, valence_shifters_dt = shifters_cn)

sent_df$id <- gsub('.txt', '', texts$doc_id)

sent_df <- sent_df[,c("id","sentence_id","sentiment")]

sent_data <- rbind(sent_data, sent_df)
}

write.csv(sent_data, paste0(gsub('texts','data/sentiment_data',dir),".csv"), row.names=F)
