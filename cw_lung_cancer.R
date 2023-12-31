#############################################
##
### Analysis of Lung cancer data
#
#
## Load required packages
library(dplyr)
library(tidyr)
library(tidyverse)
library(ggplot2)
library(survival)
library(survminer)

## Import the dataset
data <- read.csv("C:/Users/User/Documents/cw_lung_cancer.csv")

## Investigate the dataset structure
str(data)

## Descriptive statistics of the variables
summary(data)
print(table(data$sex))
print(table(data$ph.ecog))
print(table(data$status))
print(sd(data$age))
print(sd(data$ph.karno, na.rm = TRUE))
print(sd(data$pat.karno, na.rm = TRUE))
print(sd(data$meal.cal, na.rm = TRUE))


## Survival plot of the cancer patients
#
# create a survival object
sfit <- survfit(Surv(time, status)~1, data=data)
summary(sfit)
# Calculate the median survival time
median_surv_time <- surv_median(sfit)
print(median_surv_time)

# create a Kaplan-Meier survival plot
ggsurvplot(sfit, data = data, conf.int=TRUE, risk.table=TRUE,
           title="Kaplan-Meier Curve for Lung Cancer Survival", 
           risk.table.height=.3, surv.median.line = "hv")

# create a Kaplan-Meier survival plot to visualize effect of sex on survival
sfit2 <- survfit(Surv(time, status)~sex, data=data)
ggsurvplot(sfit2, data = data, conf.int=TRUE, pval=TRUE, risk.table=TRUE, 
           legend.labs=c("Male", "Female"), legend.title="Sex",  
           palette=c("dodgerblue2", "orchid2"), 
           title="Kaplan-Meier Curve for Lung Cancer Survival", 
           risk.table.height=.3)

# create a Kaplan-Meier survival plot to visualize effect of ECOG on survival
sfit3 <- survfit(Surv(time, status)~ph.ecog, data=data)
ggsurvplot(sfit3, data = data, pval=TRUE, risk.table=TRUE, 
           legend.labs=c("asymptomatic", "ambulatory",
                         "in bed <50% of the day", "in bed > 50% of the day"), 
           legend.title="ECOG", palette=c("dodgerblue2", "orchid2", "orange", "green"), 
           title="Kaplan-Meier Curve for Survival based on ECOG", 
           risk.table.height=.4)

### Cox Regression
## Univariate
# We apply the univariate coxph function to multiple covariates at once

covariates <- c("age", "sex",  "ph.karno", "ph.ecog", "pat.karno", "meal.cal")
univ_formulas <- sapply(covariates,
                        function(x) as.formula(paste('Surv(time, status)~', x)))

univ_models <- lapply( univ_formulas, function(x){coxph(x, data = data)})

# Extract data 
univ_results <- lapply(univ_models,
                       function(x){ 
                         x <- summary(x)
                         p.value<-signif(x$wald["pvalue"], digits=2)
                         wald.test<-signif(x$wald["test"], digits=2)
                         beta<-signif(x$coef[1], digits=2);#coeficient beta
                         HR <-signif(x$coef[2], digits=2);#exp(beta)
                         HR.confint.lower <- signif(x$conf.int[,"lower .95"], 2)
                         HR.confint.upper <- signif(x$conf.int[,"upper .95"],2)
                         HR <- paste0(HR, " (", 
                                      HR.confint.lower, "-", HR.confint.upper, ")")
                         res<-c(beta, HR, wald.test, p.value)
                         names(res)<-c("beta", "HR (95% CI for HR)", "wald.test", 
                                       "p.value")
                         return(res)
                         #return(exp(cbind(coef(x),confint(x))))
                       })
res <- t(as.data.frame(univ_results, check.names = FALSE))
res <- as.data.frame(res)

## Multivariate Cox regression analysis using sex and ecog only
res.cox <- coxph(Surv(time, status) ~ sex + ph.ecog, data =  data)
summary(res.cox)

## Point estimates of the regression model
data <- within(data, {
  sex <- factor(sex, labels = c("male", "female"))
  ph.ecog <- factor(ph.ecog, labels = c("asymptomatic", "ambulatory",
                                        "<50 days in bed", ">50 days in bed"))
})
cox_estimates <-
  coxph(Surv(time, status) ~ sex + ph.ecog, data = data)
ggforest(cox_estimates, data = data,
         main = "Cox regression - Point Estimates and 95% CI",
         fontsize = 1)