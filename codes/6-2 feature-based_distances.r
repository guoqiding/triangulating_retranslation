# calculate the Euclidean distances between translations
# based on the average values of 17 linguistic features

data <- read.csv("D:/project/gatsby/data/feature_document_matrix_17.csv", header=T, as.is=T)
dat <- data[,-2]
d <- aggregate(. ~ id, data = dat, FUN = "mean")
rownames(d) <- d$id
d <- d[,-1]

rn <-c('kao','wu','yao','wang','lijh','deng','chang','su','lijc')

d <- d[rn,]

# norminalize the values of different scales
for (i in 1:ncol(d)) d[,i] <- (d[,i] - mean(d[,i])) / sd(d[,i])

## calculate the Euclidean distances
dd <- dist(d)
dm <- as.matrix(dd)
for (i in 1:nrow(dm)){dm[i,i:nrow(dm)] <- ''}
dm <- dm[-1,-nrow(dm)]
dm <- dm[rev(rownames(dm)),]

write.csv(dm, "D:/project/gatsby/results/feature-based_distances_btw_translations.csv", quote=F)
