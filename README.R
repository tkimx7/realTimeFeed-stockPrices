############################################################################################################
###### --- README --- ######################################################################################
############################################################################################################
# 
### --- Here I publish codes that provide a glimpse into my automated trading strategy. My bot places daily 
### --- trades on TDAmeritrade via the "rameritrade" package, an API interface for R. The code in this 
### --- repository should help you get started with developing your own real-time feed for prices of stocks 
### --- and other financial instruments, e.g. options, of your interest. The live feed is updated every
### --- every second on R, and every minute by email should there be large price movements. Please refer to 
### --- the "rameritrade" manual on CRAN for authentication and generating your own access token. Please note 
### --- that only 120 API calls are permitted per minute. Tokens can be refreshed after 0.5 hours. Repetitive
### --- refreshing before 0.5 hours is up can result in your access getting banned. The tryCatch error script
### --- however will avoid this from happening.
