## References for data processing and plotting
## https://cran.r-project.org/web/packages/syuzhet/vignettes/syuzhet-vignette.html
## https://github.com/mjockers/syuzhet/blob/master/vignettes/syuzhet-vignette.R

# import libraries
library(syuzhet)
library(zoo)

# load the sentiment_data
data <- read.csv(file.choose(), header=T, as.is=T)

# calculate a moving average of the data
wd <- round(length(data$sentiment)*.1)
dat_rolled <- rollmean(data$sentiment, k=wd)

# sample the avaraged data with rescale_x_2
dat_list <- rescale_x_2(dat_rolled)

# plot the rescaled data
plot(dat_list$x,
     dat_list$z,
     type="l",
     main="Rescaled Sentiments of TGG",
     xlab="Narrative Time", 
     ylab="Emotional Valence")


## plot sentiments of nine translations against eng in one graph
## plot the eng sentiment first
data <- read.csv("D:/project/gatsby/data/sentiment_data/eng.csv", header=T, as.is=T)

wd1 <- round(length(data$sentiment)*.1)
dat1_rolled <- rollmean(data$sentiment, k=wd1)
dat1_list <- rescale_x_2(dat1_rolled)
dat1_sample <- round(seq(1, length(dat1_list$x), by=length(dat1_list$x)/100))

dir <- "D:/project/gatsby/data/sentiment_data/"
trans <- c('kao','wu','yao','wang','lijh','deng','chang','su','lijc')

tiff("D:/project/gatsby/results/figure5.tiff", units="in", width=8, height=6, res=300)

par(mar=c(2,2,2,1), oma = c(2, 2, 1, 1),  mfrow=c(3,3))

for (i in 1:length(trans)){
dat <- read.csv(paste0(dir, trans[i], '.csv'), header=T, as.is=T)
wd2 <- round(length(dat$sentiment)*.1)
dat2_rolled <- rollmean(dat$sentiment, k=wd2)
dat2_list <- rescale_x_2(dat2_rolled)
dat2_sample <- round(seq(1, length(dat2_list$x), by=length(dat2_list$x)/100))

plot(dat1_list$x[dat1_sample], 
     dat1_list$z[dat1_sample], 
     type="l", lty=2,
     col="blue",
     xlab="Narrative Time (sampled)", 
     ylab="Emotional Valence"
     )
lines(dat2_list$x[dat2_sample], dat2_list$z[dat2_sample], lty=1, col="red")
legend("bottomleft", c(' ST', paste0(' ', trans[i])), lty=c(2, 1), col=c('blue','red'), x.intersp = 0)
}

dev.off()
