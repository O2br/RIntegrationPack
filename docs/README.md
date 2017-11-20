## Documentation
While the User Guide is the primary source of documentation for the R Integration Pack, here is some initial information to help new users get started.

The R Integration Pack facilitates the deployment of analytics from the R statistical environment to MicroStrategy. It is intended to help MicroStrategy users extend the analytical features of the MicroStrategy platform using the capabilities of the R platform. The R Integration Pack requires a general understanding of the MicroStrategy Business Intelligence environment, such as creating metrics and using them on reports, as well as a familiarity with the R programming environment.

## Requirements
#### MicroStrategy
* MicroStrategy version 9.2.1 or higher must be installed. An exception is that to deploy a new R analytic as a derived metric in Visual Insight requires version 9.3.1.
* MicroStrategy Architect is necessary for the one-time addition of the common RScript functions.

#### R
* R must be installed on systems that will execute the R analytics deployed to MicroStrategy. This includes the MicroStrategy Intelligence Server and any MicroStrategy Desktop clients that execute R analytics as derived metrics. R is not required on other clients such MicroStrategy Web, MicroStrategy Mobile, MicroStrategy Visual Insight and MicroStrategy Office since they are consumers of analytics deployed to the MicroStrategy Intelligence Server.
* R can be installed from http://CRAN.R-project.org.
* If the R Analytic has dependencies on add-on packages that are not included standard with R, those packages must also added to the R installation on the MicroStrategy systems.

#### Installation
The R Integration Pack includes two types of installations:
* The installer provided on the Downloads tab of this site will update the MicroStrategy enviroment for executing R analytics.
* The "MicroStrategyR" package can be installed as a standard R Package from http://CRAN.R-project.org.

## Usage
These are the high-level steps for deploying an R analytics to MicroStrategy:
1. R Script: This is the R analytic to be deployed to MicroStrategy
2. Capture the R Analytic's signature: This is done in an R console using the deployR utility, which is part of the MicroStrategyR package.
3. Deploy the R Analytic to MicroStrategy: This is done in MicroStrategy by creating a new metric using the metric expression provided by the deployR utility. The metric expression for each potential output also available in the R Script itself.
