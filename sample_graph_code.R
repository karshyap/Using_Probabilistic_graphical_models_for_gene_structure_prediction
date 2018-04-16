library(ggnet)
library(network)
library(sna)
clc=function(){
  for(i in 1:100){cat("\n") }
}
setwd('/home/kashyap/Desktop/TAMU_second_semester/Probabilistic_graphical_models/Extra_project/ECEN760-extra-project-data')
net1 = rgraph(20, mode = "graph", tprob = 0.2)

v1=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     ,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0
     ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     ,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0
     ,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0
     ,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0
     ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     ,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0
     ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     ,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
     ,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0
     ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0
     ,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0
     ,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0
     ,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0
     ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

l2=matrix(v1,nrow=20)
net2=rgraph(l2,mode="graph")
net = network(l2, directed = TRUE)


# vertex names
network.vertex.names(net)=c("X9","X15","X11","X6","X5","X1","X20","X2","X7","X4","X12","X3","X8","X17","X18","X14","X19","X10","X13","X16")

k1=c("X9","X15","X11","X6","X5","X1","X20","X2","X7","X4","X12","X3","X8","X17","X18","X14","X19","X10","X13","X16")
#topo_order_nodes=[9 15 11 6 5 1 20 2 7 4 12 3 8 17 18 14 19 10 13 16];


p1=ggnet2(net, node.size = 12, node.color = "grey",label.color = "black", label=k1,label.size=4,edge.size = 0.4, edge.color = "black",arrow.size = 10,arrow.gap = 0.035)

p1
#p1=ggnet2(net, color = "phono") +scale_color_brewer("", palette = "Set1",
                     #labels = c("consonant" = "C", "vowel" = "V"),
                     #guide = guide_legend(override.aes = list(size = 6)))