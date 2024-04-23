#+
# :DESCRIPTION: Code rendering Figure 1 for Lewinska et all. 'Global overview of usable Landsat and Sentinel-2 data for 1982-2023' 
#               in preparation for Data in Brief
#
# :AUTHOR: Katarzyna Ewa Lewińska
# :DATE: 18 April 2024
# :VERSION: 1.0
# :PREREQUISITE: Local copy of the dataset: Lewińska, Katarzyna Ewa et al. (2024). Global overview of cloud-, snow-, and shade-free 
#                Landsat (1982-2023) and Sentinel-2 (2015-2023) data [Dataset]. Dryad. https://doi.org/10.5061/dryad.gb5mkkwxm
#                location specifiec with `inDir` variable
# :DISCLAIMER:   The author of this code accepts no responsibility for errors or omissions in this work
#                and shall not be liable for any damage caused by these.
#-

# :ENVIRONMENT: #
library(data.table)
library(raster)
library(sp)
library(gridExtra)
library(ggplot2)
library(grid)
library(dplyr)

# :INPUTS: #
inDir <- '/.../' # path to the folder comprising the https://doi.org/10.5061/dryad.gb5mkkwxm

td <- '2018_06_16' # target date for the data used in the Figure 1. Can be modified [YYYY_MM_DD]


# :OUTPUTS: #
outplot = paste0(inDir,'/Figure_1.jpg') #if not changed the figure will be written out to the inDir


# :CODE: #

inL <- paste0(inDir, '/GLOBAL_LND_1982-2023_CSO.csv')
inS <- paste0(inDir, '/GLOBAL_S2_2015-2023_CSO.csv')
inP <- paste0(inDir, '/GLOBAL_GrowingSeason.csv')

dbL <- fread(inL)
dbS <- fread(inS)
dbP <- fread(inP)

# select only those GS points that are in other datasets
index <- dbP$id %in% dbL$id
dbP <- dbP[index,]
dbP <- dbP[order(dbP$id),]

b <- paste0("L_",td)
bR <- paste0('Regular_',substring(td,6,10))

dataL <- dbL[,..b]
dataS <- dbS[,..b]
dataP <- dbP[,..bR] 

# Lon and Lat 
ras.xmn<-min(dbL$Lat)
ras.xmx<-max(dbL$Lat)
ras.ymn<-min(dbL$Lon)
ras.ymx<-max(dbL$Lon)

# offset the pixel origin by the 1/2 of the resolution to render correctly 
SHIFT = 0.09

crs_laea = "+proj=longlat +datum=WGS84 +no_defs"
crs_laesshift = "+proj=longlat +datum=WGS84 +towgs84=0,0,0 +no_defs"

empty <- raster(xmn=ras.xmn+SHIFT, xmx=ras.xmx+SHIFT, ymn=ras.ymn-SHIFT, ymx=ras.ymx-SHIFT, res=0.18, ncol=1997, nrows=792,
                crs=crs_laesshift)

coord <- data.frame(cbind(dbL$Lat, dbL$Lon))


# Landsat
rL <- rasterize(coord, empty, field=dataL, fun = mean, na.rm = TRUE)

# Sentinel-2
rS <- rasterize(coord, empty, field=dataS, fun = mean, na.rm = TRUE)

# Phenology
rP <- rasterize(coord, empty, field=dataP, fun = mean, na.rm = TRUE)


# Plots: Landsat
test_spdf <- as(rL, "SpatialPixelsDataFrame")
test_df <- as.data.frame(test_spdf)
colnames(test_df) <- c("value", "Latitude", "Longitude")
test_df$value <- as.factor(test_df$value)

pL <- ggplot() +  
  geom_tile(data=test_df, aes(x=Longitude, y=Latitude, fill=value), alpha=0.8) + 
  coord_equal() +
  theme_minimal() +
  ggtitle("Usable Landsat data 16 June 2018") +
  scale_fill_manual(values=c("#cccccc","#4b9abb"), 
                      labels=c('no data', 'usable data'), 
                      limits=c('0','1'), name="") + 
  theme(legend.position="bottom",
        plot.title = element_text(size=10, hjust=0),
        axis.title.y=element_text(size=8),
        axis.title.x=element_text(size=8),
        axis.text.y=element_text(size=8),
        axis.text.x=element_text(size=8),
        legend.text=element_text(size=8),
        legend.key.size = unit(0.4, 'cm'),
        legend.box.margin=margin(-10,-10,-10,-10),
        plot.margin=unit(c(-2,0.5,-1.5,0.5), "cm"))


# Plots: Sentinel-2
test_spdf <- as(rS, "SpatialPixelsDataFrame")
test_df <- as.data.frame(test_spdf)
colnames(test_df) <- c("value", "Latitude", "Longitude")
test_df$value <- as.factor(test_df$value)

pS <- ggplot() +  
  geom_tile(data=test_df, aes(x=Longitude, y=Latitude, fill=value), alpha=0.8) + 
  coord_equal() +
  theme_minimal() +
  ggtitle("Usable Sentinel-2 data 16 June 2018") +
  scale_fill_manual(values=c("#cccccc","#fcb040"), 
                    labels=c('no data', 'usable data'), 
                    limits=c('0','1'), name="") + 
  theme(legend.position="bottom",
        plot.title = element_text(size=10, hjust=0),
        axis.title.y=element_text(size=8),
        axis.title.x=element_text(size=8),
        axis.text.y=element_text(size=8),
        axis.text.x=element_text(size=8),
        legend.text=element_text(size=8),
        legend.key.size = unit(0.4, 'cm'),
        legend.box.margin=margin(-10,-10,-10,-10),
        plot.margin=unit(c(-2,0.5,-1.5,0.5), "cm"))


# Plots: Landsat + Sentinel-2
test_spdf <- as(rL+rS, "SpatialPixelsDataFrame")
test_spdf[test_spdf@data > 1] = 1
test_df <- as.data.frame(test_spdf)
colnames(test_df) <- c("value", "Latitude", "Longitude")

test_df$value <- as.factor(test_df$value)

p <- ggplot() +  
  geom_tile(data=test_df, aes(x=Longitude, y=Latitude, fill=value), alpha=0.8) + 
  coord_equal() +
  theme_minimal() +
  ggtitle("Usable Landsat and Sentinel-2 data 16 June 2018") +
  scale_fill_manual(values=c("#cccccc","#6d597a", '#6d597a'), 
                    labels=c('no data', 'usable data', ''), 
                    limits=c('0','1'), name="") + 
  theme(legend.position="bottom",
        plot.title = element_text(size=10, hjust=0),
        axis.title.y=element_text(size=8),
        axis.title.x=element_text(size=8),
        axis.text.y=element_text(size=8),
        axis.text.x=element_text(size=8),
        legend.text=element_text(size=8),
        legend.key.size = unit(0.4, 'cm'),
        legend.box.margin=margin(-10,-10,-10,-10),
        plot.margin=unit(c(-2,0.5,-2,0.5), "cm"))


# Plots: phenology
test_spdf <- as(rP, "SpatialPixelsDataFrame")
test_df <- as.data.frame(test_spdf)
colnames(test_df) <- c("value", "Latitude", "Longitude")
test_df$value <- as.factor(test_df$value)

pP <- ggplot() +  
  geom_tile(data=test_df, aes(x=Longitude, y=Latitude, fill=value), alpha=0.8) + 
  coord_equal() +
  theme_minimal() +
  ggtitle("Growing season mask 16 June") +
  scale_fill_manual(values=c("#cccccc","#55a630"), 
                    labels=c('outside growing season', 'during growing season'), 
                    limits=c('0','1'), name="") + 
  theme(legend.position="bottom",
        plot.title = element_text(size=10, hjust=0),
        axis.title.y=element_text(size=8),
        axis.title.x=element_text(size=8),
        axis.text.y=element_text(size=8),
        axis.text.x=element_text(size=8),
        legend.text=element_text(size=8),
        legend.key.size = unit(0.4, 'cm'),
        legend.box.margin=margin(-10,-10,-10,-10),
        plot.margin=unit(c(-2,0.5,-2,0.5), "cm"))



jpeg(outplot, width=2244, height=1300, units='px', res=300, quality = 100)

grid.arrange(grobs=list(pL, pS, p, pP),
             widths=c(1,1),
             heights=c(1,1)
)

dev.off()


# :END OF THE CODE: #
