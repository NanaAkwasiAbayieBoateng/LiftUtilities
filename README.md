
# LiftUtilities

<!-- badges: start -->
<!-- badges: end -->

The goal of LiftUtilities is to calculate lift ratio for fraud datasets

## Installation

You can install the released version of LiftUtilities from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages(“devtools”)
library(devtools)
install_github(“NanaAkwasiAbayieBoateng/LiftUtilities”)


```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(LiftUtilities)
## basic example code for 
library(LiftUtilities)
#load toy dataset for example
data(Liftdata)
df=Liftdata
#columns whose lift is to be calculated
cols=c("payeeCity","requestedAmountNormalizedCurrency")
#column types, continuous variables are categorized 
#into 10 equal quantiles before lift is computed
ctype=c("categorical", "continuous")
Lifter(ctype,cols,df,Fraud_column=Fraud)

```

