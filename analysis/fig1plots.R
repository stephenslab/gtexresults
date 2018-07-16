library(ggplot2)
library(cowplot)

out <- readRDS("../data/MatrixEQTLSumStats.Portable.Z.rds")
set.seed(1)

tissues <- c("Whole_Blood",
             "Brain_Cerebellar_Hemisphere",
             "Brain_Cerebellum",
             "Brain_Cortex",
             "Liver",
             "Uterus")
rows1 <- order(apply(out$strong.b,1,max),decreasing = TRUE)[1:1000]
rows2 <- order(apply(out$random.b,1,max),decreasing = FALSE)[1:1000]
rows1 <- sample(rows1,6)
rows2 <- sample(rows2,4)

B <- rbind(out$strong.b[rows1,tissues],
           out$random.b[rows2,tissues])

dat <- data.frame(x = rep(1:6,each = 10),
                  y = -rep(1:10,times = 6),
                  b = as.vector(B))
ggplot(dat,aes(x = x,y = y,fill = b)) +
  geom_raster(linetype = "solid") +
  scale_fill_gradient2(low = "darkblue",mid = "white",high = "orangered") +
  theme_cowplot()

covmat <- readRDS(paste("../output/MatrixEQTLSumStats.Portable.Z.coved.K3.P3",
                        "lite.single.expanded.rds",sep = "."))

tissues <- match(tissues,colnames(out$strong.b))

k <- 4 # 2, 3, 4
A <- covmat[[k]][tissues,tissues]

dat <- data.frame(x   = rep(1:6,each = 6),
                  y   = -rep(1:6,times = 6),
                  cov = as.vector(A))
ggplot(dat,aes(x = x,y = y,fill = cov)) +
  geom_raster() +
  scale_fill_gradient2(low = "darkblue",mid = "white",high = "orangered") +
  theme_cowplot()
