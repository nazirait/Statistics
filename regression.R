# Nazira Tukeyeva | Homework 2 
library(corrplot)
library(glmnet)
library(randomForest)
library(rpart)
library(caret)
library(ggplot2)
df <- read.csv("C:/Users/Nazira/Desktop/PW Sem 3/Statistical methods/HW2/no2.txt", sep="")
is.na(df)
summary(df)
corrplot(cor(df), method = "circle", type = "lower", tl.col = "black", tl.srt = 45)

# Visualization
ggplot(df, aes(x = cars, y = no2)) +
  geom_line() +
  labs(title = "Distribution of NO2 Level Over Number of cars",
       x = "Number of Cars",
       y = "NO2") +
  theme_minimal()

ggplot(df, aes(x = factor(hour), y = no2)) +
  geom_bar(stat = "summary", fun = "mean") +
  labs(title = "Average NO2 Level by Hour",
       x = "Hour of Day",
       y = "Average NO2 Level") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(df, aes(x = windspeed, y = no2)) +
  geom_line() +
  labs(title = "Distribution of NO2 Level by Wind Speed",
       x = "windspeed",
       y = "NO2") +
  theme_minimal()

# Linear Regression for all data
lr <- lm(no2 ~ ., data = df)  
summary(lr)
lr_acc <- summary(lr)$r.squared

# Linear Regression with statistically significant variables
sign_vars <- summary(lr)$coefficients[summary(lr)$coefficients[,4] < 0.05, , drop = FALSE]
signvars <- names(sign_vars[-1, "Estimate"])
lr2 <- lm(no2 ~ ., data = df[, c("no2", signvars)])
lr_acc2 <- summary(lr2)$r.squared

# LR: scaling features
# scaled_df <- df
# scaled_df[, -1] <- scale(df[, -1])
# lr_scaled <- lm(no2 ~ ., data = scaled_df)
# lr_acc3 <- summary(lr_scaled)$r.squared

# Box-Cox transformation
library(MASS)

# Box-Cox transformation for target var
boxcox_result <- boxcox(df$no2 ~ 1)  
lambda <- boxcox_result$x[which.max(boxcox_result$y)]
boxcox_no2 <- ifelse(lambda == 0, log(df$no2), (df$no2^lambda - 1) / lambda)

X <- data.frame(no2_boxcox = boxcox_no2, winddir = df$winddir, day=df$day, cars=df$cars, windspeed = df$windspeed, const = 1, hour = df$hour, temp = df$temp, tempdiff = df$tempdiff)

model <- lm(no2_boxcox ~ windspeed + cars + const + hour + tempdiff, data = X)
summary(model)
lr_fin <- summary(model)$r.squared






# Lasso Regression 
lasso <- glmnet(as.matrix(df[, -1]), df$no2, alpha = 1)
X <- as.matrix(df[, -1]) # predictors X
lasso_acc <- cor(predict(lasso, newx=X, s = 0.01, type = "response"), df$no2)^2
lasso_acc <- matrix(lasso_acc, ncol = 1)
lasso_acc <- as.numeric(lasso_acc)

# Random Forest
rf <- randomForest(no2 ~ ., data = df)
rf_acc <- cor(df$no2, rf$predicted)^2

# Decision Tree
dt <- rpart(no2 ~ ., data = df)
dt_acc <- cor(df$no2, predict(dt))^2

# Getting only highly correlated features as new predictors X_new
corr <- cor(df[, -1], df$no2)
abs(corr) 
X_new <- c("cars", "windspeed", "tempdiff")
df2 <- df[, c("no2", X_new)]

# RF with new features
rf2 <- randomForest(no2 ~ ., data = df2)
rf2_acc <- cor(df2$no2, rf2$predicted)^2

# DT with new features
dt2 <- rpart(no2 ~ ., data = df2)
dt2_acc <- cor(df2$no2, predict(dt2))^2

# choosing hyperparams (long run time):
# hyperparams <- expand.grid(
#  cp = seq(0.001, 0.1, by = 0.001),  
#  minsplit = c(5, 10, 15),            
#  minbucket = c(3, 5, 7))

# dt_grid <- train(no2 ~ ., data = df, method = "rpart", tuneGrid = hyperparams)
# dt_model <- dt_grid$finalModel

# Hyperparams tuning for DT:
dt_control <- rpart.control(cp = 0.001, minsplit = 5, minbucket = 3)
dt_model <- rpart(no2 ~ ., data = df, control = dt_control)
dt_r_squared <- cor(df$no2, predict(dt_model))^2


# Results
rsq <- c(lr_acc, lasso_acc, rf_acc, rf2_acc, 
         dt_acc, dt2_acc, dt_r_squared)
models <- c("LR", "LASSO", "RF", 'RF+corr',
                 "DT", "DT+corr", "DT+HyperParams")
# DT/RF+corr means models with highly correlated features

results <- data.frame(Model = models, R_squared = rsq)
par(mar = c(5, 5, 2, 2))
barplot(results$R_squared, names.arg = results$Model, 
        main = "R-squared Values for Different Models",
        xlab = "Model", ylab = "R-squared",
        col = "skyblue", ylim = c(0, 1))