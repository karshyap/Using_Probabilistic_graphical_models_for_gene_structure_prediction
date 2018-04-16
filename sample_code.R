#library(GGally)
#library(ggplot)
library(ggnet)
library(network)
library(sna)
#library(ggplot2)
train_data=read.table(file="train1000.txt",sep="\t",header=T)
net = network(train_data, directed = TRUE)
colnames(train_data)=c("X1","X2","X3","X4","X5","X6","X7","X8","X9","X10","X11","X12","X13","X14","X15","X16","X17","X18","X19","X20")

net1 = rgraph(20, mode = "graph", tprob = 0.5)
net = network(net1, directed = TRUE)

# vertex names

k1=ggnet2(network(net1, directed = TRUE),
       arrow.size = 8, arrow.gap = 0.035)