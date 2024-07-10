zbar <- function(m, zscore=T, pal=NULL, gap=0.5, family=NULL,
                 x.cex=1, x.srt=60, x.adj=0, x.off=0, x.exp=0,
                 y.cex=1, y.adj=1, y.off=0, y.exp=0,
                 leg.off=0, leg.cex=0.9, leg.cex.off=0, 
                 tick.cex=0.8, tick.off.y=0, ticklab.off.x=0,
                 alpha=1, align=0.5, rotate=0, border=NA, ylabs=NULL){

if (zscore == T){
for (i in 1:ncol(m)) m[,i] <- (m[,i] - mean(m[,i])) / sd(m[,i])
}

cols = colorRampPalette(c("#4A6FE2","#E2E2E2","#D43E6B"))(101)

if (is.null(pal)){
       cols <- cols
}  else if(length(pal)==1 & class(pal)=="function"){
       cols <- pal(101)
}  else {
       cols <- colorRampPalette(pal)(101)
}

#windowsFonts(A = windowsFont('华文细黑'))
#family <- ifelse(is.null(family), 'A', family)

par(mar=c(0,0.5,0,0.5))
ymax <- 0
for (i in 1:nrow(m)){
y <- max(m[i,]) - min(m[i,]) + 0.5
ymax <- ymax + y
}
plot(c(-0.5, ncol(m)+1+x.exp+2), c(0, ymax*1.1+y.exp), axes=F, ann=F, type="n")

mx <- max(c(abs(max(m)),abs(min(m))))
mx <- ifelse(round(mx)<mx, round(mx)+1, round(mx))
y0 <- 0
for (i in nrow(m):1){
y1 <- abs(min(m[i,])) + gap
y <- y0 + y1
y0 <- y + abs(max(m[i,]))
for (j in 1:ncol(m)){
col <- cols[round((m[i,j]+mx)/(mx*2)*100)+1]
rect(xleft=j, ybottom=y, xright=j+0.9, ytop=y + m[i,j], col=adjustcolor(col, alpha), border=border)
if(is.null(ylabs)) ylabs <- rownames(m)
text(j+0.45+x.off, ymax+0.5, names(m)[j], family=family, font=1, cex=x.cex, adj=x.adj, srt=x.srt)
text(0.65+y.off, y, ylabs[i], family=family, font=1, cex=y.cex, adj=y.adj)
lines(c(1, ncol(m)+0.9), c(y, y), lwd=0.5, col='grey')
}
}

# plot legend
scale = 15
for (i in 1:101){
    y = (i-1) * nrow(m) * 0.15 / scale + ymax*0.5
    rect(ncol(m)+1.75+x.exp+leg.off, y, ncol(m)+2.5+x.exp+leg.off, y+nrow(m)*0.15/scale, col=cols[i], border=NA)
}
text(ncol(m)+1.75+x.exp+leg.off, y+nrow(m)*4/scale+leg.cex.off, "Z-Score", family=family, font=2, adj=0, cex=leg.cex)

t <- mx/2
ticks <- seq(-mx, mx, by=t)
norm_ticks <- (ticks+mx)/(mx*2)
seg_ticks <- norm_ticks[-c(1, length(norm_ticks))]
for (i in norm_ticks){
     y = i * 100 * nrow(m) * 0.15 / scale + ymax*0.5 + tick.off.y
     text(ncol(m)+3.75+x.exp+leg.off+ticklab.off.x, y, sprintf('%.1f', ticks[norm_ticks==i]),
	      font=1, adj=c(1,0.25), cex=tick.cex)
	 lines(c(ncol(m)+2.5+x.exp+leg.off, ncol(m)+2.65+x.exp+leg.off), c(y, y), lwd=0.5, col='dimgrey')
}
}

## load the data
data <- read.csv("feature_document_matrix_17.csv", header=T, as.is=T)
dat <- data[,-2]

d <- aggregate(. ~ id, data = dat, FUN = "mean")
rownames(d) <- d$id

rown <-c('kao','wu','yao','wang','lijh','deng','chang','su','lijc')
coln <-c('kttr','cwr','rwr','mwr','idm','nn','vv','ad','con','cc','pp','pn','pun','asl','mdd','ba','bei')

d <- d[rown,coln]

tiff("figure4.tiff", units="in", width=9, height=6, res=300)
zbar(d, zscore=T, ylabs=rown, x.cex=1.35, y.cex=1.35, tick.cex=1.25, leg.cex=1.25, x.off=-0.25, ticklab.off.x=-0.2, tick.off.y=0)
dev.off()
