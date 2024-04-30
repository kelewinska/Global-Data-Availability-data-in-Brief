/*
#+
# :AUTHOR: Katarzyna Ewa Lewinska  [lewinska@hu-berlin.de]
# :DATE: 27 April 2024
# 
# :Description: Code supporting Lewinska et all. 'Global overview of usable Landsat and Sentinel-2 data for 1982-2023' 
#               in preparation for Data in Brief
#
# :Input:       
#
# :Output:  
#
# :Updates:   
#
# :2Do:       
#
# :Disclaimer:  The author of this code accepts no responsibility for errors or omissions in this work 
#               and shall not be liable for any damage caused by these.
#-
*/ 

// ### INPUTS ### \\

var points = ee.FeatureCollection("users/kelewinska/HU/Grid_18_selecton_regions");

var  AOI = points.filter(ee.Filter.gt('id', 0))
print('Number of points: ', AOI.size())

var MON = '04'    // Month o interest [mm]

// ### FUNCTIONALITY ### \\

// A function to mask out pixels that did not have observations.
var maskEmptyPixels = function(image) {
  // Find pixels that had observations.
  var withObs = image.unmask().select('SR_B4').gt(0)
  return withObs
}

var maskEmptyPixelsS = function(image) {
  // Find pixels that had observations.
  var withObs = image.unmask().select('B4').gt(0)
  return withObs
}


// ### DATA ### \\\

var date = '2020-'+MON+'-15'
var dateE = '2020-'+MON+'-16'


// Start with an image collection and mask out areas that were not observed.
var ColS = ee.ImageCollection('COPERNICUS/S2_HARMONIZED')
        .filterDate(date, dateE).filterBounds(AOI).map(maskEmptyPixelsS)
        .select('B4').count()

var Col7 = ee.ImageCollection('LANDSAT/LE07/C02/T1_L2')
        .filterDate(date, dateE).filterBounds(AOI).map(maskEmptyPixels)
        .select('SR_B4').count().unmask(0)

var Col8 = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2')
        .filterDate(date, dateE).filterBounds(AOI).map(maskEmptyPixels)
        .select('SR_B4').count().unmask(0)
        


    ColS = ColS.gt(0)
var ColL = Col7.add(Col8).gt(0) 

var ColSRep = ColS.setDefaultProjection('EPSG:4326')
var ColLRep = ColL.setDefaultProjection('EPSG:4326')


var ColLRes = ColLRep.reduceResolution({
      reducer: ee.Reducer.max(),
      maxPixels: 4096
    })

var ColSRes = ColSRep.reduceResolution({
      reducer: ee.Reducer.max(),
      maxPixels: 4096
    })


var pxSize = ee.Image.pixelArea()


var LTotal = ColLRes.gt(0).clip(AOI).multiply(pxSize).reduceRegion(ee.Reducer.sum(), AOI, 20000, 'EPSG:4326', null, false, 10000000000, 1);
print('Landsat: Proportion of sensed area', LTotal.getNumber('SR_B4').divide(400000000).divide(AOI.size()))

var STotal = ColSRes.gt(0).clip(AOI).multiply(pxSize).reduceRegion(ee.Reducer.sum(), AOI, 20000, 'EPSG:4326', null, false, 10000000000, 1);
print('Sentinel-2: Proportion of sensed area', STotal.getNumber('B4').divide(400000000).divide(AOI.size()))


/*
*/