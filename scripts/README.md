## Off-the-shelf R scripts
These ready-to-use R scripts can easily be added to your R-enabled MicroStrategy environment. Simply save them to your desktop or Intelligence Server and reference them with a MicroStrategy metric.

#### Contents
| Forecasting          | Classification      | Descriptive          |
| -------------------- | ------------------- | -------------------- |
| ARIMA                | k-Nearest Neighbors | k-Means Clustering   |
| Seasonal Forecasting | Neural Network      | k-Medoids Clustering |
| Stepwise Regression  | Naive Bayes         | Pairwise Correlation |
| Survival Analysis    | Random Forest       |                      |
|                      | Stepwise Logistic Regression |             |

#### ARIMA
One of the most common applications of predictive analytics is to forecast time-based data. This analytic uses the Auto-Regressive Integrated with Moving Average (ARIMA) algorithm to project a sequence of values ahead into the future, based on the assumption that data points taken over time may have an internal structure that can be measured. While ARIMA tends to be esoteric and complex, this analytic uses the “auto.arima” function from R’s “forecast” package to search through a variety of possible models in order to find the best one. Not only does this script generate the expected forecast values, it also provides outputs based on confidence bands, nominally set at 80% and 95% confidence levels.

![img_arima]
##### Metric Expression
'RScript<_RScriptFile="SeasonalForecasting.R", _InputNames="Target, Trend, Season", _Params="FileName=''">(Target, Trend, Season)'
* [RScript](www.google.com)
* [Documentation](www.google.com)
* [Back to the top][lnk_top]

#### Seasonal Forecasting
One of the most common applications of predictive analytics is to forecast time-based data. This analytic uses R’s ordinary least squares regression algorithm to fit the best curve that captures the general trend and seasonal variability of numerical data so it can use to predict future values.
##### Metric Expression
'RScript<_RScriptFile="SeasonalForecasting.R", _InputNames="Target, Trend, Season", _Params="FileName=''">(Target, Trend, Season)'
* [RScript](www.google.com)
* [Documentation](www.google.com)
* [Back to the top][lnk_top]

#### Stepwise Regression
Stepwise Linear Regression is a variant on classical Linear Regression in which variables are only included in the model if they have a significant effect.
##### Metric Expression
'RScript<_RScriptFile="SeasonalForecasting.R", _InputNames="Target, Trend, Season", _Params="FileName=''">(Target, Trend, Season)'
* [RScript](www.google.com)
* [Documentation](www.google.com)
* [Back to the top][lnk_top]

#### Survival Analysis
Survival Analysis can be used to predict the probability of an event occuring, such as a component failure or a customer being lost. This analytic uses the Cox Regression algorithm to quantify the effect that each independent variable has on the likelihood that such an event will occur at some point in the future.
##### Metric Expression
'RScript<_RScriptFile="SeasonalForecasting.R", _InputNames="Target, Trend, Season", _Params="FileName=''">(Target, Trend, Season)'
* [RScript](www.google.com)
* [Documentation](www.google.com)
* [Back to the top][lnk_top]

#### k-Nearest Neighbors
k-Nearest Neighbors (kNN) is a simple classification technique that is unique in the sense that no model is explicitly trained. In the kNN process, two datasets are read in: the training dataset in which the dependent variable is already known, and the test dataset in which the dependent variable is unknown. Classifications for the test set are made by determining the k most similar records in the training dataset (known as neighbors) and returning the majority vote amongst those neighbors.
##### Metric Expression
'RScript<_RScriptFile="SeasonalForecasting.R", _InputNames="Target, Trend, Season", _Params="FileName=''">(Target, Trend, Season)'
* [RScript](www.google.com)
* [Documentation](www.google.com)
* [Back to the top][lnk_top]

#### Neural Network
Neural Network is an advanced machine learning classification technique wherein a model is constructed that aims to simulate the thought process performed by the human brain. A model consists of “neurons” that are interconnected by an activation function. Every record is then passed through the network from the appropriate input neuron to the proper output neuron through a series of weights and transformations defined by the activation function.
##### Metric Expression
'RScript<_RScriptFile="SeasonalForecasting.R", _InputNames="Target, Trend, Season", _Params="FileName=''">(Target, Trend, Season)'
* [RScript](www.google.com)
* [Documentation](www.google.com)
* [Back to the top][lnk_top]

#### Naive Bayes
Naïve Bayes is a simple classification technique wherein the Naïve assumption that the effect of the value of each variable is independent from all other variables is made. For each independent variable, the algorithm then calculates the conditional likelihood of each potential class given the particular value for that variable and then multiplies those effects together to determine the probability for each class. The class with the highest probability is returned as the predicted class.
##### Metric Expression
'RScript<_RScriptFile="SeasonalForecasting.R", _InputNames="Target, Trend, Season", _Params="FileName=''">(Target, Trend, Season)'
* [RScript](www.google.com)
* [Documentation](www.google.com)
* [Back to the top][lnk_top]

#### Random Forest
Random Forest is an advanced classification technique wherein the training dataset is used to construct many independent decision trees. Every record is then passed into each individual decision tree for classification, and the class that is predicted by the majority of those decision trees is returned as the predicted class for that record.
##### Metric Expression
'RScript<_RScriptFile="SeasonalForecasting.R", _InputNames="Target, Trend, Season", _Params="FileName=''">(Target, Trend, Season)'
* [RScript](www.google.com)
* [Documentation](www.google.com)
* [Back to the top][lnk_top]

#### Stepwise Logistic Regression
Stepwise Linear Regression is a variant on classical Linear Regression in which variables are only included in the model if they have a significant effect.
##### Metric Expression
'RScript<_RScriptFile="SeasonalForecasting.R", _InputNames="Target, Trend, Season", _Params="FileName=''">(Target, Trend, Season)'
* [RScript](www.google.com)
* [Documentation](www.google.com)
* [Back to the top][lnk_top]

#### k-Means Clustering
Using the K-Means algorithm, this analytic clusters records "by their nature" so that records within a cluster have more in common with each other than with those records in the other clusters. Each cluster is defined by a central point, it's "mean".
##### Metric Expression
'RScript<_RScriptFile="SeasonalForecasting.R", _InputNames="Target, Trend, Season", _Params="FileName=''">(Target, Trend, Season)'
* [RScript](www.google.com)
* [Documentation](www.google.com)
* [Back to the top][lnk_top]

#### k-Medoids Clustering
Using the K-Medoids algorithm, this analytic clusters records "by their nature" so that records within a cluster have more in common with each other than with those records in the other clusters. Each cluster is defined by a prototypical record, it's "medoid".
##### Metric Expression
'RScript<_RScriptFile="SeasonalForecasting.R", _InputNames="Target, Trend, Season", _Params="FileName=''">(Target, Trend, Season)'
* [RScript](www.google.com)
* [Documentation](www.google.com)
* [Back to the top][lnk_top]

#### Pairwise Correlation
PairwiseCorr measures the correlation between pairs of numeric variables to show how they behave with respect to each other. The primary output of this analytic is a correlation plot and a correlation table that contain the correlations of the variables when taken in pairs.
##### Metric Expression
'RScript<_RScriptFile="SeasonalForecasting.R", _InputNames="Target, Trend, Season", _Params="FileName=''">(Target, Trend, Season)'
* [RScript](www.google.com)
* [Documentation](www.google.com)
* [Back to the top][lnk_top]


## How to use these scripts in a MicroStrategy dashboard
These R Analytics are deployed to MicroStrategy as metrics by copying the metric expressions provided here into any MicroStrategy Metric Editor. The shelf includes metric expressions for Version 1 of the R Integration Pack as well as variations that take advantage of the new features in Version 2.

Version 2 of the R Integration Pack makes it even simpler for end-users control the analytic's execution thanks to the _Params parameter that allows function parameters to be referenced by name using a string of name-value pairs. This is in addition to the original set of 27 pre-defined parameters (9 boolean, 9 numeric and 9 string).

After you've copied the metric expression for the analytic you wish to deploy:
1. Paste the Metric Expression into any MicroStrategy metric editor
2. Match analytic's inputs and function parameters for your application
3. Name and save the metric so it can be added to any MicroStrategy report or dashboard

## Disclaimers
This page provides programming examples.  MicroStrategy grants you a nonexclusive copyright license to use all programming code examples from which you can use or generate similar function tailored to your own specific needs.  All sample code is provided for illustrative purposes only. These examples have not been thoroughly tested under all conditions. MicroStrategy, therefore, cannot guarantee or imply reliability, serviceability, or function of these programs.  All programs contained herein are provided to you "AS IS" without any warranties of any kind. The implied warranties of non-infringement, merchantability and fitness for a particular purpose are expressly disclaimed.



[arima]:
[seas_forc]:
[step_reg]:
[surv]:
[knn]:
[nn]:
[nb]:
[rf]:
[step_logreg]:
[kclust]:
[kmed]:
[pair_corr]:

[lnk_top]: <www.google.com>

[img_arima]: https://github.com/MicroStrategy/RIntegrationPack/blob/master/assets/RShelf_ARIMA.png
[img_seasforc]: https://github.com/MicroStrategy/RIntegrationPack/blob/master/assets/RShelf_SeasonalForecast.PNG
[img_kclust]: https://github.com/MicroStrategy/RIntegrationPack/blob/master/assets/RShelf_kMeans.PNG
[img_kmed]: https://github.com/MicroStrategy/RIntegrationPack/blob/master/assets/RShelf_kMedoids.PNG
[img_nb]: https://github.com/MicroStrategy/RIntegrationPack/blob/master/assets/RShelf_NaiveBayes.PNG
[img_nn]: https://github.com/MicroStrategy/RIntegrationPack/blob/master/assets/RShelf_NeuralNetwork.PNG
[img_pairwise]: https://github.com/MicroStrategy/RIntegrationPack/blob/master/assets/RShelf_PairwiseCorr.PNG
[img_rf]: https://github.com/MicroStrategy/RIntegrationPack/blob/master/assets/RShelf_RandomForest.PNG
[img_survival]: https://github.com/MicroStrategy/RIntegrationPack/blob/master/assets/RShelf_Survival.PNG
[img_howtouse]: https://github.com/MicroStrategy/RIntegrationPack/blob/master/assets/RShelf_Params3.png
