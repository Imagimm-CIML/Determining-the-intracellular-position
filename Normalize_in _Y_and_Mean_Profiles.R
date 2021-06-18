library(ggplot2)

#path = "C:/Data/meresse/210408 Data for Macro analysis/Exp1 WT"
path = "path to experiment"
setwd(path)

rm(list=ls())
cat("\014")
if(!is.null(dev.list())) dev.off()


# make the intensity normalization based on the max fit intensity
liste =  1:20
plot_list = list()

for (i in liste) { 
  profile = read.csv(paste0("Lysosome RP normalised",i,".csv"), header=T, sep=",")
  profile = profile[-1]
  profile$X = round(profile$X,digits = 3)
  profile = profile [order(profile$X),]
  profile = profile[ which(profile$X>=0& profile$X <= 1), ]
  
  p = ggplot(profile, aes(x=X, y=Int)) 
  p = p +  geom_point()
  p = p +  stat_smooth(method = "loess",span = 0.1)
  
  # To find max fit y value 
  gb <- ggplot_build(p)
  max_Fit_Int = gb$data[[2]]$ymax
  max_Fit_Int[max_Fit_Int == 0] = NA
  max_Fit_Int = max(max_Fit_Int,na.rm = TRUE)
  
  p$data$Int = p$data$Int/max_Fit_Int
  plot_list[[i]] = p
  profile_N = cbind(X = profile$X,Int = p$data$Int)
  profile_N = data.frame(profile_N)
}


# make the mean profile
mean_profile_WT1 = NULL
profile = NULL

for (i in liste) { 
  profile = read.csv(paste0("Lysosome RP double normalised",i,".csv"), header=T, sep=",")
  profile = profile[-1]
  mean_profile_WT1 = rbind(mean_profile_WT1,profile)
}


plot1 = ggplot(mean_profile_WT1, aes(x=X, y=Int)) +
  geom_point()+
  stat_smooth(method = "loess",span = 0.1)+
  labs(title="Mean Plot profile WT1", x="Mean profile", y = "Intensity")

# To find max fit y value 
gb1 <- ggplot_build(plot1)
max_Fit_Int = gb1$data[[2]]$y
max_Fit_Int[max_Fit_Int == 0] = NA
max_Fit_Int = max(max_Fit_Int,na.rm = TRUE)
max_Fit_Int

plot1$data$Int = plot1$data$Int/max_Fit_Int
plot1

fit_Y1 = gb1$data[[2]]$y/max_Fit_Int
fit_Ymax1 = gb1$data[[2]]$ymax/max_Fit_Int
fit_Ymin1 = gb1$data[[2]]$ymin/max_Fit_Int

step = 1/(length(gb1$data[[2]]$y)-1)
fit_X1 = seq(0, 1, by = step)
exp1 = data.frame(X=fit_X1,Y=fit_Y1)
ggplot(exp1,aes(x=X, y=Y)) + 
  geom_ribbon(aes(ymin=fit_Ymin1, ymax=fit_Ymax1), fill = "grey70") +
  geom_line(aes(y=Y)) +
  labs(title="Mean Plot profile WT1", x="Normalized radial distance to nucleus border", y = "Normalized Intensity")


####################################################################

path = "C:/Data/meresse/210408 Data for Macro analysis/Exp2 WT"
setwd(path)

# make the intensity normalization based on the max fit intensity
liste =  1:20
plot_list = list()

for (i in liste) { 
  profile = read.csv(paste0("Lysosome RP normalised",i,".csv"), header=T, sep=",")
  profile = profile[-1]
  profile$X = round(profile$X,digits = 3)
  profile = profile [order(profile$X),]
  profile = profile[ which(profile$X>=0& profile$X <= 1), ]
  
  p = ggplot(profile, aes(x=X, y=Int)) 
  p = p +  geom_point()
  p = p +  stat_smooth(method = "loess",span = 0.1)
  
  # To find max fit y value 
  gb <- ggplot_build(p)
  max_Fit_Int = gb$data[[2]]$ymax
  max_Fit_Int[max_Fit_Int == 0] = NA
  max_Fit_Int = max(max_Fit_Int,na.rm = TRUE)
  
  p$data$Int = p$data$Int/max_Fit_Int
  plot_list[[i]] = p
  profile_N = cbind(X = profile$X,Int = p$data$Int)
  profile_N = data.frame(profile_N)
  #write.csv(profile_N,paste0("Lysosome RP double normalised",i,".csv"))
}


# make the mean profile
mean_profile_WT2 = NULL
profile = NULL

for (i in liste) { 
  profile = read.csv(paste0("Lysosome RP double normalised",i,".csv"), header=T, sep=",")
  profile = profile[-1]
  #filelist_i$X = round(filelist_i$X,digits = 3)
  #filelist_i = filelist_i [order(filelist_i$X),]
  #filelist_i = filelist_i[ which(filelist_i$X>=0& filelist_i$X <= 1), ]
  mean_profile_WT2 = rbind(mean_profile_WT2,profile)
}

plot2 = ggplot(mean_profile_WT2, aes(x=X, y=Int)) +
  geom_point()+
  stat_smooth(method = "loess",span = 0.1)+
  labs(title="Mean Plot profile WT2", x="Mean profile", y = "Intensity")

gb2 <- ggplot_build(plot2)
max_Fit_Int = gb2$data[[2]]$y
max_Fit_Int[max_Fit_Int == 0] = NA
max_Fit_Int = max(max_Fit_Int,na.rm = TRUE)

plot2$data$Int = plot2$data$Int/max_Fit_Int
plot2

fit_Y2 = gb2$data[[2]]$y/max_Fit_Int
fit_Ymax2 = gb2$data[[2]]$ymax/max_Fit_Int
fit_Ymin2 = gb2$data[[2]]$ymin/max_Fit_Int

step = 1/(length(gb2$data[[2]]$y)-1)
fit_X2 = seq(0, 1, by = step)
exp2 = data.frame(X=fit_X2,Y=fit_Y2)
ggplot(exp2,aes(x=X, y=Y)) + 
  geom_ribbon(aes(ymin=fit_Ymin2, ymax=fit_Ymax2), fill = "grey70") +
  geom_line(aes(y=Y)) +
  labs(title="Mean Plot profile WT2", x="Normalized radial distance to nucleus border", y = "Normalized Intensity")


######################################################################

path = "C:/Data/meresse/210408 Data for Macro analysis/Exp3 WT"
setwd(path)


# make the intensity normalization based on the max fit intensity
liste =  1:20
liste = liste[-10] # 10 bad points
plot_list = list()

for (i in liste) { 
  profile = read.csv(paste0("Lysosome RP normalised",i,".csv"), header=T, sep=",")
  profile = profile[-1]
  profile$X = round(profile$X,digits = 3)
  profile = profile [order(profile$X),]
  profile = profile[ which(profile$X>=0& profile$X <= 1), ]
  
  p = ggplot(profile, aes(x=X, y=Int)) 
  p = p +  geom_point()
  p = p +  stat_smooth(method = "loess",span = 0.1)
  
  # To find max fit y value 
  gb <- ggplot_build(p)
  max_Fit_Int = gb$data[[2]]$ymax
  max_Fit_Int[max_Fit_Int == 0] = NA
  max_Fit_Int = max(max_Fit_Int,na.rm = TRUE)
  
  p$data$Int = p$data$Int/max_Fit_Int
  plot_list[[i]] = p
  profile_N = cbind(X = profile$X,Int = p$data$Int)
  profile_N = data.frame(profile_N)
  #write.csv(profile_N,paste0("Lysosome RP double normalised",i,".csv"))
}

# make the mean profile
mean_profile_WT3 = NULL
profile = NULL

for (i in liste) { 
  profile = read.csv(paste0("Lysosome RP double normalised",i,".csv"), header=T, sep=",")
  profile = profile[-1]
  mean_profile_WT3 = rbind(mean_profile_WT3,profile)
}

plot3 = ggplot(mean_profile_WT3, aes(x=X, y=Int)) +
  geom_point()+
  stat_smooth(method = "loess",span = 0.1)+
  labs(title="Mean Plot profile WT3", x="Mean profile", y = "Intensity")

gb3 <- ggplot_build(plot3)
max_Fit_Int = gb3$data[[2]]$y
max_Fit_Int[max_Fit_Int == 0] = NA
max_Fit_Int = max(max_Fit_Int,na.rm = TRUE)

plot3$data$Int = plot3$data$Int/max_Fit_Int
plot3


fit_Y3 = gb3$data[[2]]$y/max_Fit_Int
fit_Ymax3 = gb3$data[[2]]$ymax/max_Fit_Int
fit_Ymin3 = gb3$data[[2]]$ymin/max_Fit_Int

step = 1/(length(gb3$data[[2]]$y)-1)
fit_X3 = seq(0, 1, by = step)
exp3 = data.frame(X=fit_X3,Y=fit_Y3)
ggplot(exp3,aes(x=X, y=Y)) + 
  geom_ribbon(aes(ymin=fit_Ymin3, ymax=fit_Ymax3), fill = "grey70") +
  geom_line(aes(y=Y)) +
  labs(title="Mean Plot profile WT3", x="Normalized radial distance to nucleus border", y = "Normalized Intensity")



###################################################################################

# make the final plot for WT and KO 

colors <- c("WT1" = "blue", "WT2" = "green", "WT3" = "red")

# overlay (legend do not work..) without normalisation 
p1 = ggplot(mean_profile_WT1, aes(x=X)) +
  stat_smooth(aes(y=Int,color="WT1"), method = "loess",span = 0.1)
p2 = p1 + stat_smooth(data = mean_profile_WT2, aes(x=X, y=Int,color="WT2"),method = "loess",span = 0.1)
p3 = p2 + stat_smooth(data = mean_profile_WT3, aes(x=X, y=Int,color="WT3"),method = "loess",span = 0.1) +
  labs(title="Mean Plot profile WT", x="Normalized radial distance to nucleus border", y = "Normalized Intensity",color = "Legend")+
  scale_colour_manual(values = colors)
p3

# overlay (legend do not work..) with normalisation 
p1 = ggplot(exp1,aes(x=X)) + 
  geom_ribbon(aes(ymin=fit_Ymin1, ymax=fit_Ymax1), fill = "grey70", alpha = .5) +
  geom_line(aes(y=Y,color = "WT1"),size=1) +
  labs(title="Mean Plot profile WT", x="Normalized radial distance to nucleus border", y = "Normalized Intensity",color="Legend")+
  scale_color_manual(values = colors)
p2 = p1 + geom_ribbon(data = exp2, aes(ymin=fit_Ymin2, ymax=fit_Ymax2), fill = "grey70", alpha=.5) +
  geom_line(data= exp2, aes(y=Y,color = "WT2"),size=1)
p3 = p2 +  geom_ribbon(data = exp3, aes(ymin=fit_Ymin3, ymax=fit_Ymax3), fill = "grey70", alpha=.5) +
  geom_line(data = exp3, aes(y=Y,color = "WT3"),size=1) +
  scale_colour_manual(name = "Legend",labels = c("WT1", "WT2", "WT3"),values = c("blue", "green", "red")) 
p3