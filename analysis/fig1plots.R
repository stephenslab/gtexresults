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
rows1 <- order(apply(abs(out$strong.b),1,max),decreasing = TRUE)[1:1000]
rows2 <- order(apply(abs(out$strong.b),1,max),decreasing = FALSE)[1:1000]
rows1 <- sample(rows1,6)
rows2 <- sample(rows2,4)

B <- rbind(out$strong.b[rows1,tissues],
           out$strong.b[rows2,tissues])

dat <- data.frame(x = rep(1:6,each = 10),
                  y = -rep(1:10,times = 6),
                  b = as.vector(B))
ggplot(dat,aes(x = x,y = y,fill = b)) +
  geom_raster() +
  scale_fill_gradient2(low = "darkblue",mid = "white",high = "orangered") +
  theme_cowplot()

genes   <- rownames(B)
tissues <- match(tissues,colnames(out$strong.b))
out     <- readRDS(paste("../output/MatrixEQTLSumStats.Portable.Z.coved.K3.P3",
                         "lite.single.expanded.V1.posterior.rds",sep = "."))
posterior.means <- out$posterior.means
B <- posterior.means[genes,tissues]

dat <- data.frame(x = rep(1:6,each = 10),
                  y = -rep(1:10,times = 6),
                  b = as.vector(B))
ggplot(dat,aes(x = x,y = y,fill = b)) +
  geom_raster() +
  scale_fill_gradient2(low = "darkblue",mid = "white",high = "orangered") +
  theme_cowplot()

covmat <- readRDS(paste("../output/MatrixEQTLSumStats.Portable.Z.coved.K3.P3",
                        "lite.single.expanded.rds",sep = "."))

k <- 54 # 2, 3, 4
A <- covmat[[k]][tissues,tissues]

dat <- data.frame(x   = rep(1:6,each = 6),
                  y   = -rep(1:6,times = 6),
                  cov = as.vector(A))
ggplot(dat,aes(x = x,y = y,fill = cov)) +
  geom_raster() +
  scale_fill_gradient2(low = "darkblue",mid = "white",high = "orangered") +
  theme_cowplot()

