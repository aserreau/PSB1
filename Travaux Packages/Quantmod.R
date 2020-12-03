library(quantmod)
library (xts)
getSymbols("AAPL",        #Recherche les données financière de AAPL : Apple Inc
           from = "2016/12/31",          
           to = "2018/12/31",
           peiodicity = "daily")  

## 'getSymbols' currently uses auto.assign=TRUE by default, but will
## use auto.assign=FALSE in 0.5-0. You will still be able to use
## 'loadSymbols' to automatically load data. getOption("getSymbols.env")
## and getOption("getSymbols.auto.assign") will still be checked for
## alternate defaults.


#Les données seront chargées dans la variable AAPL. Vous pouvez prévisualiser 
#les premières lignes des données en utilisant la fonction head(). 

head(AAPL)

#Vous pouvez récupérer l'ensemble des valeurs cotés sur le marché NASDAQ
#quantmod::getSymbols(sp100_ticker)

#You might notice that one does not need to save it as a variable. getSymbols,
#by default, will save the ticker history as a variable with the ticker name. 
#If you want to disable this function, you would set auto.assign to FALSE.
#The variable is also saved as an xts object, which is useful as it allows for 
#easy time-manipulation.

AAPL <- getSymbols("AAPL",
                   from = "2016/12/31",
                   to = "2018/12/31",
                   periodicity = "daily",
                   auto.assign = FALSE)

head(AAPL)

#You may also want to get more than one variable. To do this, you would need to 
#use lapply in combination with getSymbols. Here is how you would get the data 
#for AAPL and GOOG.

myStocks <-lapply(c("AAPL", "GOOG"), function(x) {getSymbols(x, 
                                                             from = "2016/12/31", 
                                                             to = "2018/12/31",
                                                             periodicity = "daily",
                                                             auto.assign=FALSE)} )
names(myStocks) <- c("AAPL", "GOOG")
head(myStocks$AAPL)
head(myStocks$GOOG)
adjustedPrices <- lapply(myStocks, Vo)
adjustedPrices <- do.call(merge, adjustedPrices)
head(adjustedPrices)

library(PerformanceAnalytics)

stockReturns <- Return.calculate(adjustedPrices)[-1]
head(stockReturns)

portReturns <- Return.portfolio(stockReturns, c(0.5, 0.5))
head(portReturns)

portReturnsRebalanced <- Return.portfolio(stockReturns, c(0.5, 0.5), rebalance_on = "months")
head(portReturnsRebalanced)

allPortReturns <- cbind(portReturns, portReturnsRebalanced)
colnames(allPortReturns) <- c("Non-Rebalanced", "Monthly Rebalanced")
table.AnnualizedReturns(allPortReturns, Rf = 0.1/252)
