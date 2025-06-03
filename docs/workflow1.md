# Workflow 1: Data Preprocessing

## 1. Occurrence Data
- **Source**: Compile confirmed SUDV spillover locations from peer-reviewed literature and official reports.
- **Fields**:
  - `latitude`: Decimal degrees (WGS84)
  - `longitude`: Decimal degrees (WGS84)
  - `year`: Year of spillover event
- **Output**: `data/occurrence/sudv_occurrence.csv`

## 2. Predictor Variables
- **Bioclimatic Variables**: Download from WorldClim (version 2) at 1 km² resolution:
  - `bio1_1km.tif` (Annual Mean Temperature)
  - `bio4_1km.tif` (Temperature Seasonality)
  - `bio12_1km.tif` (Annual Precipitation)
  - `bio15_1km.tif` (Precipitation Seasonality)
- **Digital Elevation Model (DEM)**:
  - `dem_1km.tif`: SRTM-derived elevation layer at 1 km².
- **Vegetation Index**:
  - `ndvi_1km.tif`: Mean NDVI from MODIS (2000–2022).
- **Rural Settlement Density**:
  - `rursite_density_1km.tif`: Derived from population grid rasters (e.g., WorldPop).
- **File Placement**: Place all raster files in `data/predictors/`.
