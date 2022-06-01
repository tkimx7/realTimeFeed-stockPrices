#.rs.restartR()
#rm(list = ls())

library(dplyr)
library(tictoc)
library(tidyverse)
library(data.table)

source("C:\\Users\\kim_t\\Desktop\\algo\\header\\headerToken.R")
source("C:\\Users\\kim_t\\Desktop\\algo\\header\\headerEmail.R")

tickers         <- c('Z','RDFN','MRNA','NCLH','SPY')
interest        <- c('Z')
tol             <- 1.005
cost            <- unlist(td_accountData()[[2]] %>% select(averagePrice))

dtt             <- as.POSIXlt(sprintf('%s %04d', Sys.Date(), 2000), format = '%Y-%m-%d %H%M')

log_            <- data.frame(matrix(nrow = 0, ncol = 6))
names(log_)     <- c('timeStamp','ticker','lastPrice','bidSize','askSize','totalVolume')

options_        <- data.frame(matrix(nrow = 0, ncol = dim(rameritrade::td_optionChain('SPY')[[2]])[2]))
names(options_) <- names(rameritrade::td_optionChain('SPY')[[2]])

i <- 1; 
j <- 1; 

while(Sys.time() < dtt) {
  
  tic(); getToken()

  err1 <- FALSE
  err2 <- FALSE
  
  tryCatch(
    
    temp1 <<- data.frame(timeStamp = as.character(Sys.time()), ticker = tickers,
              rameritrade::td_priceQuote(tickers)
              [,c('lastPrice','bidSize','askSize','totalVolume')]),
    
    error =   function(e) { err1 <<- TRUE }
  )
  if(err1 == TRUE) { print("Wait..."); Sys.sleep(5) }
  
  log_     <<-rbind(log_, temp1)
  
  print(temp1)
  
  tryCatch(
    
    options_ <<-rbind(options_, 
                lapply(tickers, function(x) rameritrade::td_optionChain(x)[[2]]) %>% bind_rows()),
    
    error =   function(e) { err2 <<- TRUE }
  )
  if(err2 == TRUE) { print("Wait..."); Sys.sleep(5) }
  
  i <- i + 1;
  j <- j + 1;
  
  if (i %% 5000 == 0) {
    
    write.csv(log_, paste0("C:\\Users\\kim_t\\Desktop\\data\\log_\\", paste0(tickers, collapse = "_"), "_", gsub(" ", "_", gsub(":", "", as.character(Sys.time()))), "_stocks.csv"))
    
    i           <- 0
    log_        <- data.frame(matrix(nrow = 0, ncol = 6))
    names(log_) <- c('timeStamp','ticker','lastPrice','bidSize','askSize','totalVolume')
  }
  if (j %% 500 == 0) {
    
    write.csv(options_, paste0("C:\\Users\\kim_t\\Desktop\\data\\log_\\", paste0(tickers, collapse = "_"), "_", gsub(" ", "_", gsub(":", "", as.character(Sys.time()))), "_options.csv"))
    
    j               <- 0
    options_        <- data.frame(matrix(nrow = 0, ncol = dim(rameritrade::td_optionChain('SPY')[[2]])[2]))
    names(options_) <- names(rameritrade::td_optionChain('SPY')[[2]])
  }
  toc(); print(paste0("i=", i, ", ", "j=", j))
  
}; 
write.csv(log_,     paste0("C:\\Users\\kim_t\\Desktop\\data\\log_\\", paste0(tickers, collapse = "_"), "_", gsub(" ", "_", gsub(":", "", as.character(Sys.time()))), "_stocks.csv"))
write.csv(options_, paste0("C:\\Users\\kim_t\\Desktop\\data\\log_\\", paste0(tickers, collapse = "_"), "_", gsub(" ", "_", gsub(":", "", as.character(Sys.time()))), "_options.csv"))

timeNext <- as.numeric(paste0(substr(Sys.time(), 12,13), substr(Sys.time(), 15,16)))
chg      <- 0

if (i > 1) {

  if (i == 2) {

    timePrev <<- as.numeric(paste0(substr(Sys.time(), 12,13), substr(Sys.time(), 15,16)))
  }
  if (timeNext > timePrev) {

    chg  <- 1
  }
}
if (chg == 1) {

  if (unlist(temp1 %>% filter(tickers == interest) %>% select(lastPrice)) > cost * tol) {

    content = paste0(interest, ": ", unlist(temp1 %>% filter(tickers == interest) %>% select(lastPrice)))

    sendEmail(content, content); print("Sending Email")

    timePrev <<- as.numeric(paste0(substr(Sys.time(), 12,13), substr(Sys.time(), 15,16)))
  }
}
