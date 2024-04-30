#+
# :DESCRIPTION: Code supporting Lewinska et all. 'Global overview of usable Landsat and Sentinel-2 data for 1982-2023' 
#               in preparation for Data in Brief
#               Comparison month-specific frequency of data availability in Landsat and Sentinel-2 time series 
#               in https://doi.org/10.5061/dryad.gb5mkkwxm dataset.
#
# :AUTHOR: Katarzyna Ewa Lewińska
# :DATE: 23 April 2024
# :VERSION: 1.1
# :PREREQUISITE: Local copy of the dataset: Lewińska, Katarzyna Ewa et al. (2024). Global overview of cloud-, snow-, and shade-free 
#                Landsat (1982-2023) and Sentinel-2 (2015-2023) data [Dataset]. Dryad. https://doi.org/10.5061/dryad.gb5mkkwxm
#                location specifiec with `inDir` variable.
#                Results from the proportionOfDataPixels.js executed in GEE. 
# :DISCLAIMER:   The author of this code accepts no responsibility for errors or omissions in this work
#                and shall not be liable for any damage caused by these.
#-

# :ENVIRONMENT: #
library(data.table)
library(raster)
library(sp)
library(grid)
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggpubr)

# :INPUTS: #
inDir <- '/.../' # path to the folder comprising the https://doi.org/10.5061/dryad.gb5mkkwxm


year <- '2020' # target year [YYYY]
day <- '15' # 15th of each month [dd]

# values derived using the proportionOfDataPixels.js
S2_acqProp2020 <- c(0.211,0.255,0.270,0.276,0.276,0.274,0.273,0.270,0.278,0.268,0.223,0.199)
LND_acqProp2020 <- c(0.126,0.143,0.156,0.174,0.175,0.185,0.176,0.185,0.175,0.158,0.139,0.117)
LND_acqProp2000 <- c(0.061,0.077,0.091,0.101,0.108,0.112,0.101,0.112,0.110,0.104,0.083,0.072)
LND_acqProp1990 <- c(0.029,0.039,0.045,0.057,0.071,0.049,0.052,0.052,0.055,0.058,0.035,0.039)

# :OUTPUTS: #
outDir = inDir  #if not changed the figure will be written out to the inDir


# :CODE: #

inL <- paste0(inDir, '/GLOBAL_LND_1982-2023_CSO.csv')
inS <- paste0(inDir, '/GLOBAL_S2_2015-2023_CSO.csv')

dbL <- fread(inL)
dbS <- fread(inS)

months <- c('01','02','03','04','05','06','07','08','09','10','11','12')

TAB2020l <- c()
TAB2020s <- c()
for(m in months){
  
  stL <- dbL %>% dplyr::select(starts_with(paste0('L_',year,'_',m,'_',day)) )
  stS <- dbS %>% dplyr::select(starts_with(paste0('L_',year,'_',m,'_',day)) )
  
  propL = sum(stL>=1)/dim(stL)[1]
  propS = sum(stS>=1)/dim(stS)[1]
  
  TAB2020l <- rbind(TAB2020l, c('Landsat 2020',m, propL))
  TAB2020s <- rbind(TAB2020s, c('Sentinel-2 2020',m, propS))
}


TAB2020 <- rbind(cbind(TAB2020l, LND_acqProp2020),cbind(TAB2020s, S2_acqProp2020))

TAB2000 <- c()

for(m in months){
  
  stL <- dbL %>% dplyr::select(starts_with(paste0('L_2000_',m,'_',day)) )

  propL = sum(stL>=1)/dim(stL)[1]

  tab <- c('Landsat 2000',m, propL)
  
  TAB2000 <- rbind(TAB2000, tab)
}

TAB2000 <- cbind(TAB2000,LND_acqProp2000)


TAB1990 <- c()

for(m in months){
  
  stL <- dbL %>% dplyr::select(starts_with(paste0('L_1990_',m,'_',day)) )
  
  propL = sum(stL>=1)/dim(stL)[1]
  
  tab <- c('Landsat 1990',m, propL)
  
  TAB1990 <- rbind(TAB1990, tab)
}

TAB1990 <- cbind(TAB1990,LND_acqProp1990)

TAB <- rbind(TAB1990,TAB2000,TAB2020)

colnames(TAB) <- c('Dataset', 'month','data_prop','acqProp')

TAB <- data.table(TAB)
TAB$data_prop <- as.numeric(TAB$data_prop)
TAB$acqProp <- as.numeric(TAB$acqProp)
TAB$month <- as.factor(TAB$month)
TAB$Satelite <- as.factor(TAB$Satellite)


TAB$coef <- TAB$data_prop/TAB$acqProp 



outplot1 = paste0(outDir, '/Figure_2.jpg')
jpeg(outplot1, width=1400, height=1100, units='px', res=400, quality = 100)

p1 = ggplot(data=TAB ) +
  geom_point(aes(x=month, y=coef, colour=Dataset, fill=Dataset ), size=2, shape=21, alpha = 0.7) + 
  theme_minimal() +
  ylim(0,0.6)+
  ggtitle("Proportion of usable observations on the 15th day of a month") +
  labs(x="month", y="proportion of valid observations")+
  scale_color_manual(values = c("#4b9abb", "#fcb040", "#6d597a", "#55a630")) +
  scale_fill_manual(values = c("#4b9abb", "#fcb040", "#6d597a", "#55a630")) +
  # scale_shape_manual(values=c(18,16,15,17))+
  theme(plot.title = element_text(size=8),
        legend.position="bottom", 
        axis.text=element_text(size=6),
        axis.title=element_text(size=6),
        legend.text=element_text(size=6),
        legend.title=element_text(size=6))+
  guides(fill=guide_legend(ncol=2),
         colour=guide_legend(ncol=2))

p1

dev.off()


# :END OF THE CODE: #
