#.rs.restartR()
#rm(list = ls())

library(rameritrade)

getToken <- function() {
  
  skip <- FALSE; tryCatch( AccessToken, error = function(e) { skip <<- TRUE } ); 
                          
  if (skip == TRUE) {
    
    AccessToken <<- td_auth_accessToken('some_token', 
                    readRDS('C:\\Users\\kim_t\\Desktop\\algo\\refreshToken.rds'))
  }
  if (as.numeric(AccessToken$expireTime - Sys.time()) < 3) {
    
    AccessToken <<- td_auth_accessToken('some_token', 
                    readRDS('C:\\Users\\kim_t\\Desktop\\algo\\refreshToken.rds'))
  }
}; getToken()
