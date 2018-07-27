# MicroStrategy R Integration Pack
#### Quick Links
* [R Integration Pack User Guide][user_guide]
* [R Script Shelf: Ready-to-use R analytics][scripts]
* [MicroStrategy R Package on CRAN][cran]
* [MicroStrategy Community - Support, examples, and more][mstr_community]
* [Installation](https://github.com/MicroStrategy/RIntegrationPack/tree/master/installers)
#

The MicroStrategy R Integration Pack makes it easy for anyone to deploy sophisticated R Metrics to any user, anywhere, any time. Thanks to an architecture designed with extensibility at its core, MicroStrategy delivers an innovative R integration that sets the standard for simplicity, scalability and performance. Now virtually any algorithm, statistic, or analysis can be added to the industry's leading Business Intelligence platform thanks to third generation features no other BI product can match:
 * No R left behind: Any R script, all R packages
 * No Servers Required: R scripts execute inside the BI engine just like our native analytics
 * Data from MicroStrategy, results from R, plus easy-to-use function parameters that give end-users process control without any coding required
 * High-Performance, COM-based execution
 * Centralized R scripts repository enables fool-proof deployment of analytics from development to production
 * R script are referenced, not embedded, making for easy maintenance and version control
 * R script errors caught and logged
 * One script, multiple execution modes
 * Support for Windows, Linux, AIX, Solaris
 * Transparent R environment: Persist/load files, objects & images, unattended package installation
 * Leverages all MicroStrategy platform features, including structured and unstructured data, in-memory cubes, re-usable metadata objects, visual data discovery, enterprise-level security and more, all seamlessly delivered via web and mobile, cloud and office.
 * Available at no extra cost

<img src="https://github.com/MicroStrategy/RIntegrationPack/blob/master/assets/MISC-0348 0518 R-integration graphic_final.jpg" width="850">

R programmers will be impressed with the drag-and-drop deployR() utility that makes capturing the metric's signature quick and easy.


But you don't need to know R to get started! Thanks to our online collection of "off-the-shelf" R metrics, any MicroStrategy user can inject R metrics to solve common business problems. Included with these metrics are powerful new tools like the predictive algorithms for ARIMA, neural network, random forests, stepwise linear and logistic regression algorithms, a pairwise variable correlation visualization, and many more. All these metrics leverage MicroStrategy's best practices and enterprise-ready robustness features. Data scientists, and especially analytics amateurs who want to learn by example, are welcome to adapt and re-purpose any of the of the source code provided with these off-the-shelf scripts.


## Getting started
Conceptually, think of the R metric as a black box with an R script inside. MicroStrategy doesn't need to know much about the R script in the black box, it only needs to know how to pass data in and after the script has executed in the R environment, how to consume the results.


#### Installation

For users who are on MicroStrategy 10.10 or older, a one-time install of R and the R script functions into your MicroStrategy environment, performed by a system administrator or anyone with permissions to install and configure software on the system. For users on MicroStrategy 10.11 or newer, the R Integration Pack comes packaged with MicroStrategy products; users will still need to install R.

#### Deployment

Delivering results from R to any BI user is what the R Integration Pack is all about. Thanks to the ever-growing collection of "off-the-shelf" R scripts, you don’t need to know anything about R code, no programming is required. If you can create a metric in MicroStrategy, and practically anyone can, then you can deploy an R metric as well. It's really that simple!




[img1]: https://github.com/MicroStrategy/RIntegrationPack/blob/master/assets/Home_RIPBlockDiagram.png

[user_guide]: <https://github.com/MicroStrategy/RIntegrationPack/raw/master/docs/Documentation_RIntegrationPackUserGuide.pdf>
[scripts]: <https://github.com/MicroStrategy/RIntegrationPack/tree/master/scripts#off-the-shelf-r-scripts>
[cran]: <https://cran.r-project.org/package=MicroStrategyR>
[mstr_community]: <https://community.microstrategy.com/s/topic/0TO44000000Flk7GAC/r-script-u108>
