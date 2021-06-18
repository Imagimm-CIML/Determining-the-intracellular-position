#install.packages("mclust")
library(mclust)
#install.packages("msir")
library(msir)
#install.packages("ggplot2")
library(ggplot2)

rm(list=ls())
cat("\014")
if(!is.null(dev.list())) dev.off()

#path = "C:/Data/meresse/210408 Data for Macro analysis/Exp1 WT"
path = "path to experiment with 20 profiles"

setwd(path)

for (i in 1:20) {

  #save graphics
  png(file=paste0("Contour RP normalized",i,".png"),width=1200, height=700)
  #load data 
  Profile_bacteria = read.csv(paste0("Lysosome RP ",i,".csv"), header=T, sep=",")
  Profile_noyau = read.csv(paste0("Dapi RP ",i,".csv"), header=T, sep=",")
  Profile_cellule = read.csv(paste0("Contour RP ",i,".csv"), header=T, sep=",")
  
  par(mfrow=c(3,1))
  
  plot(Profile_bacteria,col = "blue",main ="bacteria")
  plot(Profile_noyau,col = "red",main ="noyau" )
  plot(Profile_cellule,col = "red",main ="cellule" )
  
  # find the first X value for intensity = 0 in the DAPI profile
  #index = which(Profile_noyau$Y==0) 
  # find the first X value for intensity decrease (using diff) in the DAPI profile = minimum nucleus radius
  index = which(diff(Profile_noyau$Y) !=0)
  print(paste0("min nucleus radius = ", index[1]))
  X_border_noyau = Profile_noyau$X[index[1]]
  X_border_noyau = round(X_border_noyau)
  
  # find the first X value for intensity = 0 in the cell profile
  index2 = which(Profile_cellule$Y==0)
  index2[1]
  X_border_cellule = Profile_noyau$X[index2[1]]
  X_border_cellule = round( X_border_cellule)
  print(paste0("max cell radius = ", X_border_cellule))
  
  #double normalization on X to obtain radial profile between 0 and 1
  Profile_bacteria_corrige_x = (Profile_bacteria[,1]-X_border_noyau) /(X_border_cellule-X_border_noyau)
  Profile_bacteria_corrige_I = Profile_bacteria[,2]
  
  #to obtain the good header
  X = Profile_bacteria_corrige_x
  Int = Profile_bacteria_corrige_I
  Profile_bacteria_corrige = cbind(X,Int)
  
  #Profile_bacteria_corrige
  mtext(paste0("cell = ",i), side = 3, line = -2, outer = TRUE,cex=2,font=3)
  print(paste0("cell = ",i))
  plot(Profile_bacteria_corrige,col = "blue",main = paste0("Cell bacteria normalized = ",i))
  dev.off()
  
  # save radial profile
  filename = paste0("Lysosome RP normalised",i,".csv")
  write.csv(Profile_bacteria_corrige,filename)
}