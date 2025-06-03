# maxent_pipeline.R

# Load required libraries
library(dismo)
library(raster)
library(sp)
library(sf)
library(ggplot2)

# Set file paths
occurrence_file <- '../data/occurrence/sudv_occurrence.csv'
predictors_dir <- '../data/predictors'
results_dir <- '../results/maxent'
dir.create(results_dir, recursive = TRUE, showWarnings = FALSE)

# 1. Load occurrence data
occ <- read.csv(occurrence_file)

# 2. Load predictor rasters
predictor_files <- list.files(predictors_dir, pattern = '\\.(tif|tiff)$', full.names = TRUE)
predictor_stack <- stack(predictor_files)

# 3. Prepare coordinates
coords <- data.frame(lon = occ$longitude, lat = occ$latitude)
training_groups <- kfold(coords, k = 4)  # 75% train, 25% test

# 4. Run MaxEnt
train_occ <- coords[training_groups != 1, ]
test_occ <- coords[training_groups == 1, ]

maxent_model <- maxent(predictor_stack, train_occ)
# Save model
saveRDS(maxent_model, file.path(results_dir, 'maxent_model.rds'))

# 5. Model evaluation
eval <- evaluate(p = test_occ, a = randomPoints(predictor_stack, nrow(test_occ)), 
                 model = maxent_model, x = predictor_stack)
auc <- eval@auc
write.csv(data.frame(AUC = auc), file.path(results_dir, 'model_evaluation.csv'), row.names = FALSE)

# 6. Variable importance
var_imp <- data.frame(Variable = names(maxent_model@results),
                      Importance = maxent_model@results[, 'permutation.importance'])
write.csv(var_imp, file.path(results_dir, 'variable_importance.csv'), row.names = FALSE)

# 7. Response curves (example for first variable)
png(file.path(results_dir, 'response_curves.png'), width = 800, height = 600)
response(maxent_model)
dev.off()

# 8. Predict suitability
suitability <- predict(predictor_stack, maxent_model, progress = 'text')
writeRaster(suitability, filename = file.path(results_dir, 'suitability_map.tif'), format = 'GTiff', overwrite = TRUE)
