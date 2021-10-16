library(RSelenium)
library(rvest)
library(stringr)
eCaps <- list(chromeOptions = list(
  args = c('--headless', '--disable-gpu', '--window-size=1280,800')
))
rD <- rsDriver(extraCapabilities = eCaps,
               chromever = "latest_compatible")
ffd <- rD$client

namelink <- read.csv("namelink.csv")
profile <- data.frame(namelink[,2])

for (i in 1:nrow(namelink)) { 
  
  print(i)
  ffd$navigate(paste('',namelink[i,2],'',sep = ""))
  
  suppressMessages(try(load_btn <- ffd$findElement(using = "css", value = ".ecgEHi"), silent = TRUE)) #To get rid of the pop-up
  suppressMessages(try(load_btn$clickElement(), silent = TRUE))
  
  page <- read_html(ffd$getPageSource()[[1]])
  ratingTitle <- page %>% html_nodes(".jMkisx a") %>% html_text()
  nameTitle <- page %>% html_nodes(".cfjPUG") %>% html_text()
  UniTitle <- page %>% html_nodes(".iLYGwn a") %>% html_text()
  
  if (ratingTitle == "Add a rating."){
    next
  }
  else{
  
  NumRate <- 0
  NumRate <- (as.numeric(str_extract_all(ratingTitle, "[0-9]+")[[1]]) %/% 10) 
  
  NumRate <- NumRate+3 #number of iterations
  NumRate
  for (a in 1:NumRate)
  {
    suppressMessages(try(load_btn <- ffd$findElement(using = "css", value = ".eaZArN"), silent = TRUE))
    suppressMessages(try(load_btn$clickElement(), silent = TRUE))
    
    if (NumRate > 25){Sys.sleep(8)}
    print(a)
  }
  
  print(nameTitle)
  print(NumRate)
  print("outside loop")
  page = read_html(ffd$getPageSource()[[1]])
  
  
  quality_indv = page %>% html_nodes(".DObVa:nth-child(1) .CardNumRating__CardNumRatingNumber-sc-17t4b9u-2") %>% html_text()
  difficulty_indv = page %>% html_nodes(".cDKJcc") %>% html_text()
  description_indv = page %>% html_nodes(".gRjWel") %>% html_text()
  course_indv = page %>% html_nodes(".gxDIt") %>% html_text()
  date_indv = page %>% html_nodes(".BlaCV") %>% html_text()
  
  quality_indv <- data.frame(quality_indv)
  difficulty_indv <- data.frame(difficulty_indv)
  description_indv <- data.frame(description_indv)
  course_indv <- data.frame(course_indv)
  date_indv <- data.frame(date_indv)
  courseDate <- data.frame(course_indv, date_indv)
  
  x = 1
  while (x < nrow(courseDate)) {
    if ((courseDate[x,1] == courseDate[x+1,1])){
      courseDate[x,1] = "remove"
      #print(courseDate[x+1,])
      x <-  x+2
    }
    else {
      x <-  x+1
    }
  }
  freshcoursedate <- courseDate[courseDate$course != "remove",]
  
  professInfo = data.frame(freshcoursedate, quality_indv, difficulty_indv, stringsAsFactors =  FALSE, check.rows = TRUE)
  
  ProfnameSearch <- paste(strsplit(nameTitle, split = " ")[[1]][1], strsplit(nameTitle, split = " ")[[1]][2], "at", UniTitle,"RateMyProfessor", sep = " ")
  CSVname <- paste(ProfnameSearch,".csv",sep = "")
  
  DescriptionName <- paste("Description ", ProfnameSearch,".csv",sep = "")
  
  write.csv(description_indv, paste('C:\\Users\\Rajat\\Desktop\\Runny\\R\\YorkUKeele\\Descriptions\\', DescriptionName, sep = ""), row.names = FALSE)
  
  write.csv(professInfo, paste('C:\\Users\\Rajat\\Desktop\\Runny\\R\\YorkUKeele\\',CSVname, sep = ""), row.names = FALSE)
  
  } 
}

