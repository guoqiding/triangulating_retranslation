library(FactoMineR)
library(factoextra)
library(ggplot2)

## PCA analysis of texts from the nine translations of TGG
# based on the 17 linguistic features

dat <- read.csv("D:/project/gatsby/data/feature_document_matrix_17.csv", header=T, as.is=T)

d <- dat[,-c(1:2)]

res.pca <- PCA(d, graph = FALSE)

cp_contrib <- res.pca$eig

# scree plot for the ratio of contribution
fviz_eig(res.pca, addlabels = TRUE)

# plot figure 3(a) showing both individual and cumulative contributions by components
cp_contrib <- as.data.frame(res.pca$eig)

colnames(cp_contrib) <- c('value','individual','cumulative')

x <- rep(1:10, 2)
y <- c(cp_contrib$cumulative[1:10], cp_contrib$individual[1:10])
z <- rep(c('cumulative', 'individual'), each=10)
y <- round(y, 1)

df <- data.frame(x, y, z)
df$x <- as.factor(df$x)
df$z <- factor(df$z, levels=c('cumulative', 'individual'))

# save plot as pdf
pdf("D:/project/gatsby/results/pca_scree_figure3a.pdf", width=6, height=4.5)
ggplot(data=df, aes(x=x, y=y, color=z, linetype=z)) +
  geom_point(aes(y=ifelse(x==1, ifelse(z=='cumulative', y+.35, y-.35), y)), alpha=ifelse(x==1, .75, 1))+
  geom_text(label=paste0(y, '%'), hjust=1, vjust=ifelse(df$z=='cumulative', -.5, 1.35))+
  geom_line(aes(x=as.numeric(x)), linewidth=.5)+
  scale_x_discrete(expand=expansion(mult = c(0.15, 0.04)))+
  scale_y_continuous(limits=c(0,100), breaks=seq(0, 100, 10))+
  #scale_linetype_manual(values=c(1, 2))+
  xlab('Dimensions')+
  ylab('Percentage of explained variances')+
  guides(color=guide_legend(title='Legend', override.aes=aes(label='')), linetype=guide_legend(title='Legend'))+
  theme_bw()
dev.off()

# calculate contributions of variables to PCs (Table 6)
var <- get_pca_var(res.pca)
head(var$contrib, 4)

write.csv(var$contrib, 'D:/project/gatsby/results/pca_contrib_of_var_2_PCs.csv')


# biplot figure 3(b) showing distributions and relations of samples
labs <- c('kao','wu','yao','wang','lijh','deng','chang','su','lijc')
cols <- c('brown','skyblue','darkgreen','blue','purple','pink','red','gold','springgreen')

# save plot as pdf
pdf("D:/project/gatsby/results/pca_biplot_figure3b.pdf", width = 7, height = 6)

t_plot <- fviz_pca_biplot(res.pca, repel = F, geom = '', select.var = list(cos2 = 0.5),
                col.var = "dimgrey",
				addEllipses = TRUE, ellipse.type = 'convex', #ellipse
				col.ind = gsub('(^\\d+).*', '\\1', rownames(d))) +
                geom_text(aes(label = gsub('(^\\d+).*', '\\1', rownames(d)), color = gsub('(^\\d+).*', '\\1', rownames(d)))) +
                theme_bw() +
                scale_color_discrete(type=cols, breaks=1:9, labels=labs) +
                scale_fill_discrete(type=cols, breaks=1:9, labels=labs) +
                theme(legend.text=ggtext::element_markdown()) +
				guides(color=guide_legend(title="Translations", override.aes = aes(label = "")), fill='none')

g <- ggplotGrob(t_plot)
lbls <- 1:9
idx <- which(sapply(g$grobs[[15]][[1]][[1]]$grobs,function(i){
  "label" %in% names(i)}))
for(i in 1:length(idx)){
g$grobs[[15]][[1]][[1]]$grobs[[idx[i]]]$label <- lbls[i]
}

grid::grid.draw(g)

dev.off()


# biplot figure 3(c) showing contrast between wu's and yao's translations
dat <- read.csv("D:/project/gatsby/data/feature_document_matrix_17.csv", header=T, as.is=T)
dat$id2 <- paste0(dat$id, rep(1:29, by=9))
rownames(dat) <- dat$id2

d2 <- dat[dat$id=='wu'|dat$id=='yao',]
d2 <- d2[,-c(1,2)]

res.pca2 <- PCA(d2, graph = FALSE)

pdf("D:/project/gatsby/results/pca_biplot_figure3c.pdf", width = 5.5, height = 5)

fviz_pca_biplot(res.pca2, repel = T, geom = 'point', pointshape = 19,
                         col.ind = gsub('\\d', '', rownames(d2)),
                         select.var = list(cos2 = 0.5),
                         col.var = "dimgrey",
                         mean.point = F, legend = 'none', addEllipses=T, ellipse.type = 'convex') +
                         ggrepel::geom_text_repel(aes(label=gsub('[a-z]+', '', rownames(d2)),
                                                      color=gsub('\\d', '', rownames(d2))), size=3) +
                         scale_color_discrete(type=c('tomato','#0073cf'), labels=c('wu','yao')) +
                         guides(color=guide_legend(title='Translations', override.aes=aes(label='')), fill='none')+
                         theme_bw()
dev.off()


# biplot figure 3(c) showing contrast between yao's and chang's translations
d3 <- dat[dat$id=='yao'|dat$id=='chang',]
d3 <- d3[,-c(1,2)]

res.pca3 <- PCA(d3, graph = FALSE)

pdf("D:/project/gatsby/results/pca_biplot_figure3d.pdf", width = 5.5, height = 5)

fviz_pca_biplot(res.pca3, repel = T, geom = 'point', pointshape = 19,
                         col.ind = gsub('\\d', '', rownames(d3)),
                         select.var = list(cos2 = 0.5),
                         col.var = "dimgrey",
                         mean.point = F, legend = 'none', addEllipses=T, ellipse.type = 'convex') +
                         ggrepel::geom_text_repel(aes(label=gsub('[a-z]+', '', rownames(d3)),
                                                      color=gsub('\\d', '', rownames(d3))), size=3) +
                         scale_color_discrete(type=c('tomato','#0073cf'), labels=c('chang','yao')) +
                         guides(color=guide_legend(title='Translations', override.aes=aes(label='')), fill='none')+
                         theme_bw()
dev.off()
