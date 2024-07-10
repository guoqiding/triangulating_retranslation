library(syuzhet)
library(zoo)

## sentiment values
data <- read.csv("D:/project/gatsby/data/sentiment_data/eng.csv", header=T, as.is=T)
dir <- "D:/project/gatsby/data/sentiment_data/"
trans <- c('kao','wu','yao','wang','lijh','deng','chang','su','lijc')

#### rescale_x_2 with moving average
wd1 <- round(length(data$sentiment)*.1)
dat1_rolled <- rollmean(data$sentiment, k=wd1)
dat1_list <- rescale_x_2(dat1_rolled)
dat1_sample <- round(seq(1, length(dat1_list$x), by=length(dat1_list$x)/100))
dat1 <- dat1_list$z[dat1_sample]

df <- data.frame(eng = dat1)

for (i in 1:length(trans)){
dat <- read.csv(paste0(dir, trans[i], '.csv'), header=T, as.is=T)
wd2 <- round(length(dat$sentiment)*.1)
dat2_rolled <- rollmean(dat$sentiment, k=wd2)
dat2_list <- rescale_x_2(dat2_rolled)
dat2_sample <- round(seq(1, length(dat2_list$x), by=length(dat2_list$x)/100))
dat2 <- dat2_list$z[dat2_sample]

rdf <- data.frame(dat2)
colnames(rdf) <- trans[i]
df <- cbind(df, rdf)
}

dd <- dist(t(df))
dm <- as.matrix(dd)
for (i in 1:nrow(dm)){dm[i,i:nrow(dm)] <- ''}
dm2 <- dm[-1,-nrow(dm)]
dm2 <- dm2[rev(rownames(dm2)),]

write.csv(dm2, "D:/project/gatsby/results/sentiment-based_distances_btw_translations.csv")
