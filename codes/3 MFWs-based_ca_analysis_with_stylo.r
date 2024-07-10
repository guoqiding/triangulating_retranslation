library(stylo)
library(FactoMineR)
library(factoextra)
library(ggplot2)

data <- read.table("D:/project/gatsby/data/document_term_matrix.txt", header=T, row.names=1, as.is=T)

# removing text-specific proper names
nn <- c("盖茨比","汤姆","黛西","盖兹比","威尔逊","乔丹","贝克","纽约","黛茜","黛熙","尼克","芝加哥","西卵","布坎南","韦尔森","麦基","凯瑟琳","梅朵","牛津","乔治","科迪","卓丹","黛","杰伊","威士忌","威尔森","沃尔夫山姆","乔登","娇丹","米凯利斯","东卵","路易斯维尔","斯隆","芬兰","沃尔夫","露西尔","耶鲁","米切里斯","丹","old","sport","百老汇","渥夫斯罕","00","内哥罗","吴夫山","卡拉威","詹姆斯","牛津大学","切斯特","沃尔夫西姆","沃夫山","沃夫希姆","西恩","纽黑文")

dat <- data[!rownames(data)%in%nn,]

d <- t(data)

rownames(d) <- c('deng','lijc','lijh','kao','su','wang','wu','yao','chang')

# use modified codes for displaying xlabs for subplots
source("D:/project/gatsby/codes/3-process.metadata.R", echo = F)
source("D:/project/gatsby/codes/3-stylo2.r", echo = F)

tiff("D:/project/gatsby/results/figure2.tiff", units="in", width=9, height=6, res=300)

par(mfrow=c(2,3))

stylo(frequencies = d, mfw.min = 100, dendrogram.layout.horizontal = F, write.png.file = F, custom.graph.title = '(a)', gui = T, outer = F)
stylo(frequencies = d, mfw.min = 200, dendrogram.layout.horizontal = F, write.png.file = F, custom.graph.title = '(b)', gui = T, outer = F)
stylo(frequencies = d, mfw.min = 500, dendrogram.layout.horizontal = F, write.png.file = F, custom.graph.title = '(c)', gui = T, outer = F)
stylo(frequencies = d, mfw.min = 1000, dendrogram.layout.horizontal = F, write.png.file = F, custom.graph.title = '(d)', gui = T, outer = F)
stylo(frequencies = d, mfw.min = 1500, dendrogram.layout.horizontal = F, write.png.file = F, custom.graph.title = '(e)', gui = T, outer = F)
stylo(frequencies = d, mfw.min = 2000, dendrogram.layout.horizontal = F, write.png.file = F, custom.graph.title = '(f)', gui = T, outer = F)

dev.off()

#Reference: Evert, S., Proisl, T., Jannidis, F., Reger, I., Pielstrom, S., Schoch, C. and Vitt, T. (2017). Understanding and explaining Delta measures for authorship attribution. Digital Scholarship in the Humanities, 32(suppl. 2): 4-16.