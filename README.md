# Statistical Methods and Data Analysis using Python and R

### Problem 1: Air Pollution Analysis – NO₂ Regression Modeling (regression.R)

Models:
- Linear Regression: all predictors, statistically significant predictors only, with box-cox transformation
- Benchmarking with other models: Lasso Regression, Random Forest Regressor, Decision Tree Regressor

- Feature Selection Based on Correlation
- ***Hyperparameter Tuning*** (Decision Tree Optimization)
<img width="1000" height="500" alt="image" src="https://github.com/user-attachments/assets/682097fb-099e-4168-bf7f-1fe1538eff8a" />

### Problem 2: Biking Accidents Analysis (accidents.ipynb)
- Identifying factors contributing to all cycling accidents
- Identifying factors contributing specifically to deadly accidents
- Investigating the impact of geographical stratification (Borough/Ward)

### Problem 3: Time Series Analysis - Wisła River Water Level (wisla.ipynb)
- Identifying trend and seasonality
- Testing for stationarity
- Fitting the best ARMA model
- Fitting 1-step-ahead rolling forecast
- Detecting major departures from model predictions

<Figure size 864x576 with 4 Axes><img width="856" height="568" alt="image" src="https://github.com/user-attachments/assets/18e9b091-660d-4a1e-9b7c-9a55510e77d5" />

### Problem 4: Spatial Interpolation of Rainfall in Switzerland (interpolation.ipynb)

This problem focuses on predicting rainfall across Switzerland using spatial interpolation methods. The objective was to compare spatial interpolation techniques and evaluate their predictive performance using Mean Squared Error (MSE).

- Inverse Distance Weighting (IDW)
- Ordinary Kriging
- Universal Kriging (with altitude as external drift)

| Method                | MSE      |
| --------------------- | -------- |
| **IDW**               | 6233.34  |
| **Ordinary Kriging**  | 9436.67  |
| **Universal Kriging** | 10197.93 |





