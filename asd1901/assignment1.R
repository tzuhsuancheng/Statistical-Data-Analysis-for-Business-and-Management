#' ---
#' title: "Assignment1"
#' author: "Cheng"
#' date: "9/30/2019"
#' output:
#'   word_document: default
#'   html_document:
#'     df_print: paged
#'     number_sections: yes
#'     toc: yes
#'     toc_depth: 4
#'     toc_float: yes
#'   pdf_document:
#'     toc: yes
#'     toc_depth: '4'
#' ---
#' 
## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)

#' 
#' # Question1
#' *The exam results of Statistics are listed as data. Please make a numerical and graphical summary of the data, commenting on any features that you find interesting.*
## ------------------------------------------------------------------------
setwd("~/Desktop/NTU/02/Business Analytics/assignment/asd1901")

# Data Input
score = 
  c(94, 81, 79, 66, 96, 73, 70, 68, 94, 70,
    64, 84, 66, 64, 80, 76, 87, 65, 65, 91,
    60, 68, 62, 90, 95, 62, 69, 66, 80, 61,
    77, 60, 66, 52, 82, 63, 81, 62, 73, 92,
    81, 67, 84, 70, 78, 48, 86, 87, 81, 79) %>%
  as.tibble() %>% 
  rename(Y = value)

attach(score)

#' Numerical & Graphical Summary
## ------------------------------------------------------------------------
# Histogram & Boxplot
par(mfrow = c(1,2))
hist(Y, freq = TRUE, ylab = "Frequency", xlab = "score", main = "Histogram of Score") 
boxplot(Y, xlab = "score", main = "Boxplot of Score")

#' Summary Report
## ------------------------------------------------------------------------
summary(Y)

# End of Analysis
detach()

#' 
#' According to the histogram, the socre mainly fall between 60-70 and then fall in 75-90. And from the boxplot and summary report, we can find that the mean of score is around 74.3, and the first and the third qunatitle are 65.25 and 81.75. The maximum is 96, the minimum is 48.
#' 
#' # Question2
#' *A manufacturer produces custom metal blanks that are used by its customers for computer-aided machining. The customer sends a design via computer (a 3-D blueprint), and the manufacturer comes up with an estimated cost per unit, which is then used to determine a price for the customer. This analysis considers the factors that affect the cost to manufacture these blanks. The data for analysis, “production_cost_1.txt”, were sampled from the accounting records of 195 previous orders that were filled during the last 3 months.*
#' 
## ------------------------------------------------------------------------
# Data Input
pc = read.table("production_costs_1.txt", header = TRUE)
attach(pc)

# Take a look of the data
summary(pc)

#' 
#' ## (a) 
#' *Create a scatterplot for the average cost per item on the material cost per item. Do you find a linear pattern?*
## ------------------------------------------------------------------------
plot(AvgMaterialCost, AvgTotalCost)
abline(lm(AvgTotalCost ~ AvgMaterialCost), lwd=2)
title("(a) Scatter Plot", lwd=2)

#' 
#' As you can see from the Scatterplot, there is a light linear pattern between AvgMaterailCost and AvgTotalCost.
#' 
#' ## (b)
#' *Estimate the linear equation using least squares. Interpret the fitted intercept and slope. Be sure to include their units.*
#' 
## ------------------------------------------------------------------------
fit1 = lm(AvgTotalCost ~ AvgMaterialCost)
summary(fit1)

#' 
#' According to the SLR result of AvgTotalCost and AvgMaterialCost, we can expect when the average material cost increase by one unit, the average total cost would increase 2.7403 unit. To be more meaningful to say, when we expect the average total cost to increase by $2.74 when average material cost increase by $1.
#' 
#' ## (c) 
#' *Interpret $R^2$ and $\hat{\sigma}$ *
## ------------------------------------------------------------------------
summary(fit1)$r.squared

#' The value of R suqred is 0.1336, which means only 13.36% of the variation in the average total cost can be explained by a straight-line relationship between average total cost and average material cost.
#' 
## ------------------------------------------------------------------------
summary(fit1)$sigma

#' The value of residual standard error is 8.360321, which shows the average difference between fitted values and observed values.
#' 
#' ## (d)
#' *What is the estimated increase in the total cost per finished item if the material cost per unit goes up by $3? *
## ------------------------------------------------------------------------
3 * summary(fit1)$coef[2]

#' 
#' If the material cost per unit goes up by $3, then the estimated increase in the total cost per unit would go up by $8.221032
#' 
#' ## (e)
#' *One can argue that the slope in this regression should be 1, but it is not. Explain the difference.*
#' 
#' From the view of mathematics, since the coefficient of SLM is calculated by minimizing the sum of squared errors, we can get more fitting results.
## ------------------------------------------------------------------------
plot(AvgMaterialCost, AvgTotalCost)
abline(lm(AvgTotalCost ~ AvgMaterialCost), lwd=2)
abline(summary(fit1)$coef[1], 1, col = "red")
title("(e) Scatter Plot")

#' Also, I would like to visit the scatter plot again. And I'm goning to add a line with the same intercept but its slope equals to 1. From the plot, we can easily see that the slope equaling 2.74 is fitted better than the slope equaling to 1. 
#' 
#' ## (f)
#' The total cost of an order in these data was $61.16 per unit with material cost of $4.18 per unit.
#' Is this a relatively expensive order given the material cost?
## ------------------------------------------------------------------------
new <- data.frame(AvgMaterialCost = 4.18)
predict(fit1, new)

#' Our prediction of total cost per unit given average material cost = $4.18 is $44.6052. Besides, the mean of the average total cost is 39.54. Therefore, the total cost of $61.16 per unit is relatively expansive. 
#' 
#' ## (g)
#' *Plot the residuals from this regression. What does the standard deviation of the residuals tell about the fit of this equation?*
#' 
#' Residual plots: x-axis: X values
## ------------------------------------------------------------------------
plot(AvgMaterialCost, residuals(fit1), xlab="AvgMaterialCost", ylab="Residuals")

#' 
#' Standard deviation of the residuals
## ------------------------------------------------------------------------
SSE = sum(residuals(fit1)^2)
sigma.hat = sqrt(SSE/(nrow(pc)-2))
sigma.hat

# End of Analysis
detach()

#' The standard deviation of the residuals shows the distance between known data points and those data points predicted by the model. We can say that on average, using the least squares regression line to predict average total cost per unit from reported average material cost, results in an error of about $8.36. If we can get this number smaller, than our regression would be more well-fitted.
#' 
#' 
#' # Question3
#' *Utility companies in many older communities still rely on “meter readers” who visit homes to read meters that measure consumption of electricity and gas. Unless someone is home to let the meter reader inside, the utility company has to estimate the amount of energy used. The utility company in this example sells natural gas to homes in the Philadelphia area. Many of these are older homes that have the gas meter in the basement. We can estimate the use of gas in these homes with a simple linear model. The explanatory variable is the average number of degrees below 65 during the billing period, and the response is the number of hundred cubic feet of natural gas (CCF) consumed during the billing period (about a month). The explanatory variable is set to 0 if the average temperature is above 65 (assuming a homeowner won’t need heating in this case).*
#' 
## ------------------------------------------------------------------------
# Data Input
gas = read.table("gas_consumption.txt", header = TRUE)
attach(gas)

#' 
#' ## (a)
#' *Use R to fit a simple linear model with the date “gas_consumption.txt”. Do the analysis, make the plot, and summarize the results.*
#' 
#' * Goal: Estimate the use of gas in these homes with a simple linear model. 
#' 
#' * Y: `Gas.CCF` the number of hundred cubic feet of natural gas (CCF) consumed during the billing period (about a month) 
#' 
#' * X: `DegreeBelow65` the average number of degrees below 65 during the billing period
#' 
#' ### EDA
## ------------------------------------------------------------------------
# Histogram & Boxplot
par(mfrow = c(2,2))
hist(Gas.CCF, freq = TRUE, ylab = "Frequency", xlab = "Gas", main = "Histogram of Gas") 
boxplot(Gas.CCF, xlab = "Gas", main = "Boxplot of Gas")

hist(DegreesBelow65, freq = TRUE, ylab = "Frequency", xlab = "DegreesBelow65", main = "Histogram of DegreesBelow65") 
boxplot(DegreesBelow65, xlab = "DegreesBelow65", main = "Boxplot of DegreesBelow65")

#' 
#' We can easily find that the distribution of Gas and Degrees are pretty similar.
#' 
## ------------------------------------------------------------------------
# Scatterplot
plot(DegreesBelow65, Gas.CCF)
abline(lm(Gas.CCF ~ DegreesBelow65), lwd=2)
title("Scatterplot", lwd=2)

#' 
#' Also, the scatterplot shows the good linear pattern between Gas and Degrees!
#' 
## ------------------------------------------------------------------------
# summary Report
gas %>%
  select(Gas.CCF, DegreesBelow65) %>%
  summary() 

#' 
#' ### Analyze model
## ------------------------------------------------------------------------
fit3 = lm(Gas.CCF ~ DegreesBelow65)
summary(fit3)

#' 
#' 1. Residual standard error = 16.09
#' 
#' 2. R-squared = 0.9552
#' 
#' 3. The coefficient of DegreeBelow65 = 5.6928 (statistically significant since the p-value < 0.001)
#' 
#' ### Diagnose model
## ------------------------------------------------------------------------
par(mfrow = c(1,3), pty = "s")

# x-axis: X values
plot(DegreesBelow65, residuals(fit3), xlab="DegreesBelow65", ylab="Residuals")
abline(h=0)
title("Risidual plots")

# histogram
hist(residuals(fit3))

# qq-plot
qqnorm(residuals(fit3), ylab="Residuals")
qqline(residuals(fit3))

#' 
#' Check the assumptions of residuals:
#' 
#' 1. Risiudal plots: PASS
#' 
#' 2. Histogram of residuals: Fail
#' 
#' 3. QQ-plots: Fail
#' 
#' When checking the assumptions of residuals, we can find that our model seems to break the assumptions of normality. We should be questionable about the model unless we find the remedies to modify the model.
#' 
#' ## (b)
#' *Modify the script provided for this lecture to create the “Confidence and Prediction Intervals” plot shown on lecture note p. 2-32 and re-printed below.*
#' CI & PI plot
## ------------------------------------------------------------------------
# CI setup
xy <- data.frame(DegreesBelow65 = pretty(DegreesBelow65))
yhat <- predict(fit3, newdata=xy, interval="confidence")
ci <- data.frame(lower=yhat[,"lwr"], upper=yhat[,"upr"])

# PI setup
yhat.pi <- predict(fit3, newdata=xy, interval="prediction")
pi <- data.frame(lower=yhat.pi[,"lwr"], upper=yhat.pi[,"upr"])

# observation setup
plot(DegreesBelow65, Gas.CCF, main ="Confidence and Prediction Intervals",
	ylab = "Y = Gas", 
	xlab = "X = Degrees")

# lines
abline(fit3)
lines(xy$DegreesBelow65, ci$lower, lty=2, col="red")
lines(xy$DegreesBelow65, ci$upper, lty=2, col="red")
lines(xy$DegreesBelow65, pi$lower, lty=2, col="blue")
lines(xy$DegreesBelow65, pi$upper, lty=2, col="blue")


#' 
#' 
#' 
#' 
#' 
#' 
