# Objective 3: Environmental Niche Modeling of Sudan ebolavirus (SUDV)

## Overview
This repository contains data, code, and documentation for ecological niche modeling (ENM) of Sudan ebolavirus (SUDV) occurrence in Uganda.

### Contents
- `data/`
  - `occurrence/sudv_occurrence.csv`: Presence locations for SUDV spillover events.
  - `predictors/`: Environmental predictor raster files (e.g., bioclimatic variables, NDVI, DEM, rural settlement density).
- `code/`
  - `maxent_pipeline.R`: R script to run MaxEnt modeling and output results.
  - `session_info.R`: R script capturing session info for reproducibility.
- `docs/`
  - `workflow1.md`: Detailed description of data preprocessing workflow.
  - `workflow2.md`: Detailed description of modeling and analysis workflow.
- `README.md`: This file.
- `LICENSE`: Creative Commons Attribution 4.0 International (CC BY 4.0).
- `CITATION.cff`: Citation metadata for this repository.
- `requirements.txt`: R package dependencies.
- `zenodo.json`: Metadata for Zenodo deposition.

## Usage
1. **Occurrence Data:** Populate `data/occurrence/sudv_occurrence.csv` with georeferenced SUDV spillover events.
2. **Predictor Rasters:** Place environmental rasters (e.g., `bio1_1km.tif`, `bio4_1km.tif`, etc.) into `data/predictors/`.
3. **R Environment:** Install required R packages (see `requirements.txt`).
4. **Run Modeling:** Execute `code/maxent_pipeline.R` to perform MaxEnt modeling and generate outputs.
5. **Reproducibility:** Run `code/session_info.R` to save R session details to `session_info.txt`.

## Data Availability
All occurrence and predictor data, along with modeling scripts, are archived on GitHub (URL placeholder) and Zenodo (DOI placeholder), licensed under CC BY 4.0.
