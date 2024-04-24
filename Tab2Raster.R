#+
# :DESCRIPTION: Code supporting Lewinska et all. 'Global overview of usable Landsat and Sentinel-2 data for 1982-2023' 
#               in preparation for Data in Brief
#               An example how to cast the tabulated data https://doi.org/10.5061/dryad.gb5mkkwxm into a 
#               geotiff in the EPSG:4326 projection.
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
library(grid)


# :INPUTS: #
inDir <- '/.../' # path to the folder comprising the https://doi.org/10.5061/dryad.gb5mkkwxm

td <- '2018_06_16' # target date for the data used in the Figure 1. Can be modified [YYYY_MM_DD]


# :OUTPUTS: #
outRas = paste0(inDir,'/Geotiff_example.TIF') #if not changed the figure will be written out to the inDir


# :CODE: #

inD <- paste0(inDir, '/GLOBAL_LND_1982-2023_CSO.csv')

dbL <- fread(inD)

b <- paste0("L_",td)

dataL <- dbL[,..b]


## Define projection parmeters ## 

# Lon and Lat 
ras.xmn<-min(dbL$Lon)
ras.xmx<-max(dbL$Lon)
ras.ymn<-min(dbL$Lat)
ras.ymx<-max(dbL$Lat)

# offset the pixel origin by the 1/2 of the resolution to render correctly 
SHIFT = 0.09

crs_laea = "+proj=longlat +datum=WGS84 +no_defs"
crs_laesshift = "+proj=longlat +datum=WGS84 +towgs84=0,0,0 +no_defs"

# the size of the output raster is predefined as 1997x792
empty <- raster(xmn=ras.xmn+SHIFT, xmx=ras.xmx+SHIFT, ymn=ras.ymn-SHIFT, ymx=ras.ymx-SHIFT, res=0.18, ncol=1997, nrows=792,
                crs=crs_laesshift)

coord <- data.frame(cbind(dbL$Lon, dbL$Lat))


# Rasterize tabulated data
rL <- rasterize(coord, empty, field=dataL, fun = mean, na.rm = TRUE)

# Write out the raster
writeRaster(rL, filename=outRas ,format="GTiff", overwrite=TRUE)



# :END OF THE CODE: #
