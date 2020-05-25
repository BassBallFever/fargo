#-----------------------------------------------------------------------
#               Impute the missing values
#-----------------------------------------------------------------------

# Impute missing values with Amelia package
# Install and load the Amelia package
install.packages("Amelia")
require(Amelia)

# Load the data
data <- read.csv("Z:/Documents/UWSP/DS 700/Final Project/Dataset.csv")

summary(data)

plot(data$Incoming.Examinations, main="Heart Exams by Month", xlab="Month", ylab="Heart Exams")

# Impute the missing values
a.out <- amelia(data, ts = "Month")

# Create a CSV with the missing values
write.amelia(a.out, file.stem = "imp")





# Impute missing values using weighted averages

# Install and load package
install.packages("imputeTS")
require(imputeTS)

# Run an exponential weighted average to impute the missing data
imp <- na.ma(data, k = 4, weighting = "exponential")

write.csv(imp, file="imputed.csv")






#-----------------------------------------------------------------------
#               Forcast
#-----------------------------------------------------------------------

# Load packages
require(forecast)
require(MLmetrics)

# Attempt Holt Winters forecast

# Load the dataset
forecast <- read.csv("Z:/Documents/UWSP/DS 700/Final Project/Dataset.csv", header = T)

# Find the best alpha value
forecast.mean <- HoltWinters(forecast$Weighted.Averages, gamma=FALSE)


# Build a time series from data
myTS  <- ts(forecast$Weighted.Averages)

# Examine plot of the time series
plot(myTS, ylab = "Number of Exams", xlab = "Months")


# Use the Holt Winters model to predict the next 12 months
holtForecasts  <- forecast(forecast$Weighted.Averages, h=12)

# plot the predictions
plot(holtForecasts, xlim=c(80,115), main="Holt Winters Forecast", xlab="Months", ylab="Number of Examinations")

# Assess the time series using MAD and MAPE
mad(holtForecasts$residuals)
MAPE(holtForecasts$residuals, holtForecasts$fitted)

# Analyze the forecast
summary(holtForecasts)


# Attempt ARIMA forecast

# Load the forecast package
require(forecast)

# Load the dataset
forecast <- read.csv("Z:/Documents/UWSP/DS 700/Final Project/Dataset.csv", header = TRUE)

# Build a time series from data
myTS  <- ts(forecast$Weighted.Averages)

# Examine plot of the time series
plot(myTS, ylab = "Number of Exams", xlab = "Months")

# Assess the time series using ACF and PACF
acf(myTS)
pacf(myTS)

# Use diffing for data transformation
ndiffs(x = myTS)

# fit the ARIMA model
arimaForecast  <- auto.arima(x = myTS)

# Assess the time series using MAD and MAPE
mad(arimaForecast$residuals)
MAPE(arimaForecast$residuals, arimaForecast$fitted)

# Use the ARIMA model to predict the next 12 months
futureForecasts  <- forecast(arimaForecast, h=12)

# plot the predictions
plot(futureForecasts, xlim=c(80,115), main="ARIMA Forecast", xlab="Months", ylab="Number of Examinations")

# Analyze the forecast
summary(futureForecasts)
