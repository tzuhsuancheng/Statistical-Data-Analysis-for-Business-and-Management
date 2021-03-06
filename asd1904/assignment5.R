#' ---
#' title: "Ass5"
#' author: "商研二 鄭子萱"
#' date: "12/27/2019"
#' output:
#'   html_document:
#'     df_print: paged
#'     number_sections: yes
#'     toc: yes
#'     toc_depth: 4
#'     toc_float: yes
#'   pdf_document:
#'     toc: yes
#'     toc_depth: '4'
#'   word_document: default
#' ---
#' 
## ----setup, include=FALSE, echo=FALSE------------------------------------
require("knitr")
opts_knit$set(root.dir = "~/Desktop/NTU/02/Business Analytics/assignment/asd1905")

#' 
## ---- warning=FALSE, message = FALSE-------------------------------------
library(Sleuth2)
case2102

#' 
#' # Q1
#' For the Moth Coloration data (case2102), consider the response count to be the number of light months removed and the binomial denominator to be the total number of months removed (light and dark) at each location.
#' 
#' ## (a) 
#' Fit the logistic regression model with distance as the explanatory variable; then report the
#' estimates and standard errors.
## ------------------------------------------------------------------------
moth <- aggregate(case2102$Removed, by = list(case2102$Distance), FUN = sum)
names(moth) <- c("Distance", "TtlRemoved")
moth$LightRemoved <- subset(case2102$Removed, case2102$Morph == "light")
moth$LightLeft <- moth$TtlRemoved - moth$LightRemoved

#' 
## ------------------------------------------------------------------------
attach(moth)
moth.bn <- glm(cbind(LightRemoved, LightLeft) ~ Distance, family = binomial)
summary(moth.bn)

#' 
#' The estimate of the intercept is 0.2805 with standard error = 0.2309, and the slope estimate of Distance is -0.0187 with standard error 0.0068.
#' 
#' ## (b) 
#' Compute the deviance goodness-of-fit test statistic, and obtain a p-value for testing the
#' adequacy of the model. 
#' 
## ------------------------------------------------------------------------
1 - pchisq(moth.bn$deviance, moth.bn$df.residual)

#' 
#' From the summary report showing in 1. (a), the residual deviance statistic is 2.0741 with degree of freedom = 5. The p-value for goodness of fit is 0.8388 and therefore there is no evidence for lack of fit.
#' 
#' # Q2
#' The dataset vitaminC is from a randomized experiment to assess the effect of large doses of vitamin C on the incidence of colds. The subjects were given tablets to take daily, but neither the subjects nor the doctors who evaluated them were aware of the dose of vitamin C contained in the tablets. The data shows the proportion of subjects in each of the four dose categories who did not report any illness during the study period.
#' 
#' ## (a) 
#' Fit the logistic regression model. Report the estimated coefficients and their standard errors. Summarize the findings of this model.
## ------------------------------------------------------------------------
vitc <- read.table("vitaminC.txt", sep = "\t", header = TRUE)
vitc
vitc$Ill <- vitc$Number - vitc$WithoutIllness

#' 
## ------------------------------------------------------------------------
attach(vitc)
vitc.bn <- glm(cbind(Ill, WithoutIllness) ~ Dose, binomial)
summary(vitc.bn)

#' In the full model, the estimate of the intercept is 1.2003 with standard error = 0.0617. The slope estimate of Dose is 0.0347 with standard error 0.0713 but not significant at the 5% level. 
#' 
## ------------------------------------------------------------------------
1 - pchisq(vitc.bn$deviance, vitc.bn$df.residual)
vitc.bn.ndose <- update(vitc.bn, . ~ . - Dose)
summary(vitc.bn.ndose)

#' 
#' 
#' ## (b) 
#' What can be concluded about the adequacy of the logistic regression model? What evidence is there that the odds of a cold are associated with the dose of vitamin C? 
## ------------------------------------------------------------------------
1 - pchisq(vitc.bn.ndose$deviance, vitc.bn.ndose$df.residual)

#' 
#' The p-value for goodness of fit in the reduced model is 0.8571 and therefore there is no evidence for lack of fit. It means there is not much evidence that the odds of a cold are associated with the daily dose of vitamin C.
#' 
#' 
#' # Q3
#' Data ex1028 in Sleuth2 package shows the number of Atlantic Basin tropical storms and hurricanes for each year from 1950 to 1997. The variable storm index is an index of overall intensity of the hurricane season. (It is the average of number of tropical storm, number of hurricanes, the number of days of tropical storms, the number of days of hurricanes, the total number of intense hurricanes, and the number of days they last – when each of these is expressed as a percentage of the average value for that variable. A storm index score of 100, therefore, represents, essentially, an average hurricane year.) Also listed are whether the year was cold, warm, or neutral El Nino year, a constructed numerical variable temperature that takes on the values -1, 0, and 1 according to whether the El Nino temperature is cold, neutral, or warm; and a variable indicating whether West Africa was wet or dry that year. It is though that wet years in West Africa often bring more hurricanes.
#' 
#' Use Poisson log-linear regression to describe the distribution of (a) number of storms and (b) number of hurricanes as a function of El Nino temperature and West Africa wetness
#' 
#' ## (a)
## ------------------------------------------------------------------------
ex1028
attach(ex1028)

#' 
## ------------------------------------------------------------------------
storm <- glm(Storms ~ relevel(as.factor(Temperature), '1') + as.factor(WestAfrica), family = poisson)
summary(storm)

#' In the full model of storm, the estimate of the intercept is 1.9325, and the slope estimates of cold and neutral El Nino Year are 0.3765 and 0.3125, respectively. However, that of wet West Africa year is 0.1560, which is not significant at the 5% level. 
#' 
## ------------------------------------------------------------------------
storm.red <- glm(Storms ~ relevel(as.factor(Temperature), '1'), family = poisson)
summary(storm.red)

#' Next we try to drop WestAfrica to get the reduced model of storm. 
#' 
## ------------------------------------------------------------------------
1 - pchisq(storm$deviance, storm$df.residual)
1 - pchisq(storm.red$deviance, storm.red$df.residual)

#' 
#' The p-value for goodness of fit in the reduced model is 0.8290 and therefore there is no evidence for lack of fit. It means there is not much evidence that the average number of storms are associated with West Africa wetness after accounting for El Nino temperature.
#' 
#' ## (b)
## ------------------------------------------------------------------------
hrk <- glm(Hurricanes ~ relevel(as.factor(Temperature), '1') + as.factor(WestAfrica), family = poisson)
summary(hrk)
1 - pchisq(hrk$deviance, hrk$df.residual)

#' 
#' In the full model, the estimate of the intercept is 1.3414, and the slope estimates of cold and warm El Nino Year are 0.4621 and 0.4174, respectively. However, that of wet West Africa year is 0.2190, which is not significant at the 5% level but significant at the 10% level. The p-value for goodness of fit in the full model is 0.9771 and therefore there is no evidence for lack of fit. It means there is ‘some’ evidence that the average number of hurricanes are associated with West Africa wetness.
#' 
