#.rs.restartR()
#rm(list = ls())

library(mailR)

sendEmail <- function(subject_, body_) {

  err1 <- FALSE
  
  tryCatch(

  #subject_ = "test"
  #body_ = "test"
    
  send.mail(authenticate = TRUE,
            from         = "some_addressa@gmail.com",
            to           = "some_address@gmail.com>",
            subject      = subject_,
            body         = body_,
            encoding     = "utf-8",
            smtp         = list(host.name = "smtp.gmail.com", 
                                port      = 465, 
                                user.name = "some_address@gmail.com", 
                                passwd    = "some_pswd", 
                                ssl       = TRUE),
            send = TRUE),
  
  error = function(e) { err1 <<- TRUE }
  )
  if (err1 == TRUE) {
  
    print("Wait for Gmail API to Respond..."); Sys.sleep(61)  
    sendEmail(subject_, body_)
  }
  
 
