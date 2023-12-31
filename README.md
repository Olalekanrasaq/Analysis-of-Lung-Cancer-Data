# Analysis of Lung Cancer Data

Analysis of Lung Cancer Data to investigation Eastern Cooperative Oncology Group (ECOG) performance score as a predictor for survival lung cancer patients

## Introduction
Lung cancer is the leading cause of cancer-related deaths in many of the developed countries. One of the reasons lung cancer is at the top of the list is that it is often not diagnosed until the cancer is at an advanced stage. Thus, the earliest diagnosis of lung cancer is crucial to ensure earlier treatment. Data containing subjects with advanced lung cancer from the North Central Cancer Treatment Group was thereby analyzed to investigate if the Eastern Cooperative Oncology Group (ECOG) performance score is a predictor for survival lung cancer patients.

## Method
The data was analyzed using R programming language. The descriptive statistics of the population characteristics was carried out and the influence of the several features of the dataset in predicting survival of lung cancer was explored using Cox regression analysis, with major focus on ECOG score. Univariate Cox regression analysis was first explored to identify significant features. The significant features were then supplied to the multivariate Cox regression model to describe how the factors jointly impact on survival. The survival plot of the patients over time was plotted via Kaplan-Meier (K-M) survival curves while the survival curves patients based on sex and ECOG were compared.

## Results
From the study, the Cox regression model revealed sex and ECOG as the only significant features for predicting the survival of lung cancer with a p-value of less than 0.05. The p-value for ECOG score is 6.56e-06, with a hazard ratio HR = 1.53, indicating a strong relationship between the ECOG value and increased risk of death. Holding the other covariates constant, a higher value of ECOG score is associated with a poor survival.
