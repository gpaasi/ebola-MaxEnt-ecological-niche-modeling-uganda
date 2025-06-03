# Workflow 2: MaxEnt Modeling and Analysis

## 1. Environment Setup
- Install R (>= 4.0.0) and required packages listed in `requirements.txt`.
- Ensure `data/occurrence/sudv_occurrence.csv` and predictor rasters are in place.

## 2. Running MaxEnt
- Script: `code/maxent_pipeline.R`
- **Steps**:
  1. Load occurrence data (`sudv_occurrence.csv`) into R.
  2. Stack predictor rasters using the `raster` package.
  3. Partition data: 75% for training, 25% for testing (e.g., `dismo::kfold`).
  4. Run MaxEnt using `dismo::maxent()`, with default regularization.
  5. Evaluate model performance (AUC, omission rates).
  6. Generate response curves and variable importance tables.
  7. Project suitability across Uganda: `predict()` on full raster stack.
  8. Save output rasters (e.g., `suitability_map.tif`) and evaluation metrics.

## 3. Interpreting Results
- Summarize environmental suitability for spillover.
- Identify high‐risk areas (top 10% suitability).
- Discuss variable contributions and thresholds for presence.

## 4. Outputs
- **Model Outputs**:  
  - `results/maxent/suitability_map.tif`  
  - `results/maxent/response_curves.png`  
  - `results/maxent/variable_importance.csv`
- **Evaluation Metrics**:  
  - Stored in `results/maxent/model_evaluation.csv`

## 5. Reproducibility
- Run `code/session_info.R` to record R session details to `session_info.txt`.
