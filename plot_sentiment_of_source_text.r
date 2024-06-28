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
