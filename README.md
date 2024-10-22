# Global Data Availability: Data in Brief

Codes to accompany the Lewińska et al. (2004)[1] paper featuring the Global Data *Global overview of cloud-, snow-, and shade-free Landsat (1982-2023) and Sentinel-2 (2015-2023) data* featuring the dataset Lewińska et al., (2024)[2].
The prerequisite to executing the codes is the local copy of the Dataset featured in the publication. 

- `Figure_1.R` code generates [*Figure 1*](https://github.com/kelewinska/Global-Data-Availability-data-in-Brief/blob/main/Figure_1.jpg) featured in the Lewińska et al. (2024a) paper; 
- `Figure_2.R` code generating [*Figure 2*](https://github.com/kelewinska/Global-Data-Availability-data-in-Brief/blob/main/Figure_2.jpg) featured in the Lewińska et al. (2024a) paper; 
- `proportionOfDataPixels.js` code deriving global statistics on proportion of acquired observations needed in the ` Figure_2.R` script. To be executed in GEE
- `Tab2Raster.R` showcases the casting of the tabulated data from Lewińska et al. (2024b) as a georeferenced raster in the EPSG:4326 projection. A correctly casted resulting raster will have the following extend and projection definition:
```
Driver: GTiff/GeoTIFF
Files: Geotiff_example.tif
Size is 1997, 792
Coordinate System is:
GEOGCRS["WGS 84",
    ENSEMBLE["World Geodetic System 1984 ensemble",
        MEMBER["World Geodetic System 1984 (Transit)"],
        MEMBER["World Geodetic System 1984 (G730)"],
        MEMBER["World Geodetic System 1984 (G873)"],
        MEMBER["World Geodetic System 1984 (G1150)"],
        MEMBER["World Geodetic System 1984 (G1674)"],
        MEMBER["World Geodetic System 1984 (G1762)"],
        MEMBER["World Geodetic System 1984 (G2139)"],
        ELLIPSOID["WGS 84",6378137,298.257223563, LENGTHUNIT["metre",1]], ENSEMBLEACCURACY[2.0]], PRIMEM["Greenwich",0,
        ANGLEUNIT["degree",0.0174532925199433]], CS[ellipsoidal,2],
        AXIS["geodetic latitude (Lat)",north, ORDER[1], ANGLEUNIT["degree",0.0174532925199433]],
        AXIS["geodetic longitude (Lon)",east, ORDER[2], ANGLEUNIT["degree",0.0174532925199433]],
    USAGE[SCOPE["Horizontal component of 3D system."], AREA["World."], BBOX[-90,-180,90,180]],
    ID["EPSG",4326]]
Data axis to CRS axis mapping: 2,1
Origin = (-179.796651242645993,83.418336693230899)
Pixel Size = (0.180000000000000,-0.180000000000000)

Corner Coordinates:
Upper Left  (-179.7966512,  83.4183367) (179d47'47.94"W, 83d25' 6.01"N)
Lower Left  (-179.7966512, -59.1416633) (179d47'47.94"W, 59d 8'29.99"S)
Upper Right ( 179.6633488,  83.4183367) (179d39'48.06"E, 83d25' 6.01"N)
Lower Right ( 179.6633488, -59.1416633) (179d39'48.06"E, 59d 8'29.99"S)
Center      (  -0.0666512,  12.1383367) (  0d 3'59.94"W, 12d 8'18.01"N)
```
## Conditions of use
Upon using the dataset and the accompanying materials please cite Lewińska et al. (2024) [1,2].

## References:
* [1] Lewińska K.E., Ernst S., Frantz D., Leser U., Hostert P., (2024) Global Overview of Usable Landsat and Sentinel-2 Data for 1982–2023. Data in Brief (2024), [https://doi.org/10.1016/j.dib.2024.111054](https://doi.org/10.1016/j.dib.2024.111054)
Interactive GEE App to explore the dataset: https://katarzynaelewinska.users.earthengine.app/view/worlddataaval
* [2] Lewińska K.E., Ernst S., Frantz D., Leser U., Hostert P. (2024). Global overview of cloud-, snow-, and shade-free Landsat (1982-2023) and Sentinel-2 (2015-2023) data [Dataset]. Dryad. https://doi.org/10.5061/dryad.gb5mkkwxm

##
#### Landsat data availability
<p align="center" width="100%">
    <img width="50%" src="https://github.com/kelewinska/Global-Data-Availability-data-in-Brief/blob/main/LND_ts84-22.gif"> 
</p>

