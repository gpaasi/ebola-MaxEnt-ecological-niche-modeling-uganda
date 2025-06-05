# Ebola virus MaxEnt Ecological Niche Modeling (Uganda)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15600735.svg)](https://doi.org/10.5281/zenodo.15600735)  
[![GitHub](https://img.shields.io/badge/GitHub-ebolavirus--MaxEnt--ecological--niche--modeling--uganda-blue?logo=github&logoColor=white)](https://github.com/gpaasi/ebola-MaxEnt-ecological-niche-modeling-uganda)

Reproducible pipeline, data, and interactive visualization for  
**“Environmental niche modeling of ebolavirus occurrence in Uganda.”**

---

## Table of Contents
1. [Overview](#overview)  
2. [Repository Structure](#repository-structure)  
3. [Data Description](#data-description)  
4. [Installation & Environment Setup](#installation--environment-setup)  
5. [Workflow 1: Data Preprocessing & Predictor Preparation](#workflow-1-data-preprocessing--predictor-preparation)  
6. [Workflow 2: MaxEnt Modeling & Analysis](#workflow-2-maxent-modeling--analysis)  
7. [Running the Pipeline](#running-the-pipeline)  
8. [Interpreting & Visualizing Results](#interpreting--visualizing-results)  
9. [Reproducibility & Session Info](#reproducibility--session-info)  
10. [How to Cite](#how-to-cite)  
11. [License](#license)  
12. [Zenodo Deposition](#zenodo-deposition)  
13. [Contact Information](#contact-information)  

---

## Overview
This repository contains all data, code, and documentation needed to perform environmental niche modeling (ENM) of Sudan ebolavirus (SUDV) occurrence in Uganda. Using MaxEnt (Phillips et al., 2017), we identify areas of high ecological suitability for SUDV spillover based on climatic, topographic, vegetation, and human settlement predictors.

**Key Objectives:**
- Compile and clean georeferenced SUDV occurrence points (2000–2022).
- Assemble and preprocess high-resolution predictor rasters (bioclimatic variables, DEM, NDVI, rural settlement density).
- Implement a fully documented MaxEnt modeling pipeline in R (`maxent_pipeline.R`).
- Evaluate model performance using AUC, ROC curves, and omission rates.
- Generate both continuous and binary habitat suitability maps.
- Ensure full reproducibility via detailed workflows and session metadata.

---

## Repository Structure

```

sudv-enm-uganda/
├── README.md                                ← This file (project overview & instructions)
├── LICENSE                                  ← CC BY 4.0 license text
├── CITATION.cff                             ← Citation metadata for GitHub/Zenodo
├── requirements.txt                         ← R package dependencies
├── zenodo.json                              ← Metadata for Zenodo deposition
├── data/
│   ├── occurrence/
│   │   └── sudv\_occurrence.csv              ← Georeferenced SUDV spillover events
│   └── predictors/
│       ├── bio1\_1km.tif                     ← Annual Mean Temperature (°C) \[WorldClim v2.1]
│       ├── bio4\_1km.tif                     ← Temperature Seasonality \[WorldClim v2.1]
│       ├── bio12\_1km.tif                    ← Annual Precipitation (mm) \[WorldClim v2.1]
│       ├── bio15\_1km.tif                    ← Precipitation Seasonality \[WorldClim v2.1]
│       ├── dem\_1km.tif                      ← Elevation (m) \[SRTM v3]
│       ├── ndvi\_1km.tif                     ← Mean NDVI (MODIS 2000–2022)
│       ├── rursite\_density\_1km.tif          ← Rural population density (WorldPop 2020 + ESA CCI 2015)
│       └── README\_predictors.md             ← Detailed metadata & preprocessing notes
├── code/
│   ├── maxent\_pipeline.R                    ← Fully commented R script to run MaxEnt, evaluation, projection
│   └── session\_info.R                       ← R script to record sessionInfo() to `session_info.txt`
└── docs/
├── workflow1.md                         ← Detailed “Data Preprocessing & Predictor Preparation”
└── workflow2.md                         ← Detailed “Modeling & Analysis with MaxEnt”

````

---

## Data Description

### 3.1 Occurrence Data (`data/occurrence/sudv_occurrence.csv`)
- **Purpose**: Contains georeferenced SUDV spillover events in Uganda. Each row is a unique, confirmed occurrence.
- **Columns**:
  1. `latitude` – Decimal degrees (WGS84).  
  2. `longitude` – Decimal degrees (WGS84).  
  3. `year` – Four-digit year of spillover (e.g., 2000, 2011, 2012, 2022).  
  4. `source` – Citation or DOI for the original report (e.g., “Okware et al. (2002)”).  
  5. `notes` – Additional context (e.g., “Gulu district index case, adult patient”).  
- **Quality Control**:
  - Ensure coordinates fall within Uganda’s bounding box: lat [−1.5, 4.0], lon [29.5, 36.0].  
  - Remove duplicates (identical lat/lon).  
  - Validate in R against an official shapefile (see `docs/workflow1.md`).

**Example Content (sudv_occurrence.csv)**:
```csv
latitude,longitude,year,source,notes
0.347600,32.582500,2000,"Okware et al. (2002)","Gulu District index case, adult patient"
0.659500,31.846300,2011,"Shoemaker et al. (2012)","Luwero pediatric re‐emergence"
0.774300,31.088300,2012,"Albariño et al. (2013)","Kibaale rural cluster"
0.613400,32.459600,2022,"WHO AFRO SitRep (Oct 2022)","Mubende RRH cluster, healthcare worker"
# Add additional rows as discovered...
````

---

### 3.2 Environmental Predictors (`data/predictors/`)

All predictor rasters are GeoTIFFs, CRS = EPSG:4326 (WGS84), resolution = 0.008333° (\~1 km²), extent = Uganda + 50 km buffer.

1. **`bio1_1km.tif`**

   * **Variable**: Annual Mean Temperature (°C)
   * **Source**: WorldClim v2.1 (1970–2000 average)
   * **Processing**: Cropped to Uganda + 0.5° buffer, masked to national boundary, converted from tenths °C → °C, resampled to 1 km.

2. **`bio4_1km.tif`**

   * **Variable**: Temperature Seasonality (Standard Deviation × 100)
   * **Source**: WorldClim v2.1
   * **Processing**: Cropped, masked, and resampled identically to bio1.

3. **`bio12_1km.tif`**

   * **Variable**: Annual Precipitation (mm)
   * **Source**: WorldClim v2.1
   * **Processing**: Cropped, masked, resampled to 1 km.

4. **`bio15_1km.tif`**

   * **Variable**: Precipitation Seasonality (Coefficient of Variation)
   * **Source**: WorldClim v2.1
   * **Processing**: Same as other bioclim variables.

5. **`dem_1km.tif`**

   * **Variable**: Elevation (meters above sea level)
   * **Source**: SRTM v3 (30 m original)
   * **Processing**: Mosaic HGT tiles, reproject to EPSG:4326, resample to 1 km (bilinear), crop & mask to Uganda + buffer.

6. **`ndvi_1km.tif`**

   * **Variable**: Mean NDVI (Normalized Difference Vegetation Index)
   * **Source**: MODIS MCD43A4 composite (2000–2022)
   * **Processing**: Stack 16-day NDVI layers, compute multi-year mean, resample to 1 km, crop & mask to Uganda + buffer.

7. **`rursite_density_1km.tif`**

   * **Variable**: Rural population density (people per km²)
   * **Source**: WorldPop 2020 population + ESA CCI 2015 land cover
   * **Processing**: Reclassify land cover to rural mask, aggregate WorldPop 100 m → 1 km, mask to rural areas, crop & mask to Uganda + buffer.

8. **`README_predictors.md`**

   * Detailed metadata for each raster: source URL, download date, original CRS & resolution, preprocessing steps (resample, crop, mask), extent, NoData handling, and QA checks.

---

## Installation & Environment Setup

### 4.1 System Requirements

* **Operating System**: Windows, macOS, or Linux
* **R**: Version ≥ 4.0.0 ([https://cran.r-project.org/](https://cran.r-project.org/))
* **RStudio**: Recommended but optional
* **Java**: Version ≥ 1.8.0 (required for MaxEnt)

### 4.2 Clone the Repository

```bash
git clone https://github.com/YourUser/sudv-enm-uganda.git
cd sudv-enm-uganda
```

### 4.3 Install Required R Packages

Open an R console (or RStudio) and run:

```r
# Core dependencies (minimum versions specified)
install.packages(c(
  "raster",    # >= 3.4-13
  "dismo",     # >= 1.3-4
  "rgdal",     # >= 1.5-23
  "sp",        # >= 1.4-5
  "sf",        # >= 1.0-8
  "ggplot2",   # >= 3.3.0
  "viridis",   # >= 0.6.0
  "dplyr"      # >= 1.0.0
))
```

If you need to install specific versions, use the `remotes` package:

```r
# Example: install a particular version of raster
install.packages("remotes")
remotes::install_version("raster", version = "3.4-13")
```

### 4.4 Install & Verify Java

MaxEnt requires Java runtime. To install Java:

* **Windows**: Download Java SE 8 JRE from [https://java.com/download/](https://java.com/download/) and install.
* **macOS**: Use Homebrew: `brew install --cask adoptopenjdk8` (Java 8).
* **Linux**: `sudo apt-get install default-jre` (usually installs Java 8+).

Verify installed Java version:

```bash
java -version
# Expected: java version "1.8.0_xxx"
```

---

## Workflow 1: Data Preprocessing & Predictor Preparation

See [docs/workflow1.md](docs/workflow1.md) for a fully detailed, step-by-step guide on:

1. Compiling and validating SUDV occurrence records.
2. Downloading raw predictor rasters (WorldClim, SRTM, MODIS, WorldPop, ESA CCI).
3. Cropping, resampling, and masking rasters to a 1 km grid (Uganda + buffer).
4. Conducting QA checks to ensure all rasters have consistent CRS, resolution, and extent.
5. Documenting every step in `data/predictors/README_predictors.md`.

---

## Workflow 2: MaxEnt Modeling & Analysis

See [docs/workflow2.md](docs/workflow2.md) for a comprehensive, line-by-line explanation of how to:

1. Load occurrence and predictor data into R.
2. Partition data using 5-fold cross-validation.
3. Generate background points for MaxEnt.
4. Train the MaxEnt model with specified arguments (randomseed, responsecurves, replicates).
5. Evaluate model performance (AUC, ROC curve, omission rates) and save metrics.
6. Extract variable importance and response curves, saving both CSV and plots.
7. Project continuous habitat suitability across Uganda and save as GeoTIFF + PNG.
8. Threshold continuous output to a binary map using the 10% training omission threshold.
9. Save all outputs (model object, evaluation, plots, rasters) to `results/maxent/`.
10. Record R session details for reproducibility in `session_info.txt`.

---

## Running the Pipeline

After you have completed Workflows 1 & 2:

1. **Ensure Data & R Environment**

   * Confirm that `data/occurrence/sudv_occurrence.csv` is populated with valid points.
   * Confirm that all predictor `.tif` files exist in `data/predictors/` and match descriptions in `README_predictors.md`.
   * Verify R packages are installed and Java is accessible.

2. **Run the MaxEnt Script**

   ```r
   # In R console or RStudio, from the project root:
   source("code/maxent_pipeline.R")
   ```

   This script will:

   * Load and partition occurrence data.
   * Generate background points.
   * Train the MaxEnt model and save the model object.
   * Evaluate model performance (AUC, ROC curve, omission).
   * Extract variable importance and save plots.
   * Project continuous suitability and save as GeoTIFF + PNG.
   * Produce a binary suitability map (10% threshold).
   * Record session information (`session_info.txt`).

3. **Inspect Outputs**

   * All outputs are saved to `results/maxent/` (create this folder if it does not exist).
   * Expected files and folders under `results/maxent/`:

     ```
     maxent_model.rds
     model_evaluation.csv
     roc_curve.png
     variable_importance.csv
     variable_importance.png
     responsecurves/         ← Contains individual response curve plots for each predictor
     suitability_map.tif
     suitability_map.png
     binary_suitability_map.tif
     binary_map.png
     ```
   * The `session_info.txt` file will appear in the repository root, detailing your R version and package versions.

---

## Interpreting & Visualizing Results

1. **Model Performance**

   * Open `results/maxent/model_evaluation.csv` to see AUC (e.g., 0.85 indicates strong performance).
   * View `results/maxent/roc_curve.png` for a visual ROC curve.

2. **Variable Importance**

   * Examine `results/maxent/variable_importance.csv` to identify which predictors drive model performance.
   * View `results/maxent/variable_importance.png` to see a bar chart of permutation importance.

3. **Response Curves**

   * The `results/maxent/responsecurves/` directory contains plots showing how predicted suitability changes with each predictor.
   * Interpret ecological relationships (e.g., optimum temperature, precipitation range).

4. **Continuous Suitability Maps**

   * `results/maxent/suitability_map.tif` is a GeoTIFF of continuous suitability (cloglog).
   * `results/maxent/suitability_map.png` overlays occurrence points on the suitability gradient.

5. **Binary Suitability Maps**

   * `results/maxent/binary_suitability_map.tif` is a 0/1 map using the 10% training omission threshold.
   * `results/maxent/binary_map.png` visualizes suitable vs. unsuitable areas, highlighting high-risk zones.

---

## Reproducibility & Session Info

* **`code/session_info.R`** captures the R session environment (R version, OS, and package versions) to `session_info.txt`:

  ```r
  sessionInfo() %>% capture.output(file = "session_info.txt")
  ```
* **`session_info.txt`** (in the repository root) ensures full reproducibility of the software environment used.

---

## How to Cite

When using any data or code from this repository, please cite:

> **Paasi, G.; Okwware, S.; Olupot-Olupot, P. (2025).**
> *Environmental Niche Modeling of Sudan ebolavirus (SUDV) in Uganda.*
> Zenodo. [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15600735.svg)](https://doi.org/10.5281/zenodo.15600735)  


> Commit: `abcdef1234567890abcdef1234567890abcdef12`

---

## License

This repository and all its contents are licensed under the **Creative Commons Attribution 4.0 International (CC BY 4.0)**.
See [LICENSE](LICENSE) for full details.

---

## Zenodo Deposition

After creating a GitHub release (e.g., `v1.0.0`), Zenodo will automatically archive that release and mint a DOI. The `zenodo.json` file provides metadata for Zenodo:

```json
{
  "title": "Environmental Niche Modeling of Sudan ebolavirus (SUDV) in Uganda",
  "upload_type": "dataset",
  "description": "Data and code for ecological niche modeling of SUDV occurrence in Uganda. Includes occurrence CSV, predictor rasters, R scripts (MaxEnt pipeline and session info), detailed workflows, and reproducibility metadata. Licensed under CC BY 4.0.",
  "creators": [
    {"name": "Paasi, George", "orcid": "0000-0001-6360-0589"},
    {"name": "Okwware, Sam"},
    {"name": "Olupot-Olupot, Peter"}
  ],
  "license": "CC-BY-4.0"
}
```

Once Zenodo assigns the DOI, replace `XXXXXXXX` in this README and in `CITATION.cff`.

---

## Contact Information

**Lead Author**:
George Paasi, PhD
Clinical Trials Department, Mbale Clinical Research Institute
Department of Community & Public Health, Busitema University Faculty of Health Sciences
Mbale, Uganda
Email: [georgepaasi8@gmail.com](mailto:georgepaasi8@gmail.com)

**Co‐Authors**:
Sam Okwware, MBChB, MPH. PhD
Uganda National Health Research Organisation (UNHRO)

Peter Olupot‐Olupot, MD, PhD
Mbale Clinical research institute (MCRI)
polupotolupot@gmail.com  
