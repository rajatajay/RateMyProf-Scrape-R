library(RSelenium)
library(rJava)      # Needed for tabulizer
library(tabulizer)  # Handy tool for PDF Scraping
library(tidyverse)  # Core data manipulation and visualization libraries
library(rvest)
library(xlsx)

eCaps <- list(chromeOptions = list(
  args = c('--headless', '--disable-gpu', '--window-size=1280,800')
))

rd <- rsDriver(extraCapabilities = eCaps) #Running headless chrome
ffd <- rd$client
ffd$navigate("https://www.ratemyprofessors.com/search/teachers?query=*&sid=1495") #Currently entered YorkU, CAD
ffd$screenshot(display = TRUE) #Just to check if you've got the right page

Sys.sleep(2)

load_btn <- ffd$findElement(using = "css", value = ".gvGrz") #To get rid of the pop-up # ".ecgEHi" previous pop up
load_btn$clickElement() 

check <- 1

while (check == 1)
{
  load_btn <- ffd$findElement(using = "css", value = ".gjQZal")
  #page = read_html(ffd$getPageSource()[[1]]) # ".eaZArN"
  load_btn$clickElement() #To press show more
  Sys.sleep(10)
}
# It will eventually move on after reaching the end of the page

page = read_html(ffd$getPageSource()[[1]]) # Reads the entire page 

init_name <-  page %>% html_nodes(".cJdVEK") %>% html_text()
quality = page %>% html_nodes(".CardNumRating__CardNumRatingNumber-sc-17t4b9u-2") %>% html_text()
difficulty = page %>% html_nodes(".enhFnm+ .fyKbws .hroXqf") %>% html_text()

init_num_rate <-  page %>% html_nodes(".jMRwbg") %>% html_text()

init_wouldtakeagain <- page %>% html_nodes(".fyKbws:nth-child(1) .hroXqf") %>% html_text()

course = page %>% html_nodes(".haUIRO") %>% html_text()
campus = page %>% html_nodes(".iDlVGM") %>% html_text()

namelink <- page %>% html_nodes(".dLJIlx") %>% html_attr("href") %>% paste("https://www.ratemyprofessors.com", ., sep = "") 


init_profess <- data.frame(init_name, quality, difficulty, init_num_rate, init_wouldtakeagain, course, campus,namelink, stringsAsFactors =  FALSE)

init_profess <- init_profess %>% separate(init_name, c("first_name", "last_name"), " ")
init_profess <- init_profess %>% separate(init_num_rate, c("num_rate"), " ")
init_profess <- init_profess %>% separate(init_wouldtakeagain, c("would_take_again"), "%")

profess <- data.frame(init_profess, stringsAsFactors =  FALSE)

write.csv(profess, "C:\\Users\\Rajat\\Desktop\\Runny\\R\\RateMyProf-Scrape-R\\YorkUPenultimate.csv") #change uni name each time

#After this step there is collecting individual details of every professors review


Sys.sleep(20)

for (i in 1:nrow(profess)) {

  ffd$navigate(paste('',profess[i,9],'',sep = ""))

  suppressMessages(try(load_btn <- ffd$findElement(using = "css", value = ".ecgEHi"), silent = TRUE)) #To get rid of the pop-up
  suppressMessages(try(load_btn$clickElement(), silent = TRUE))

  NumRate <- 0
  NumRate <- ((strtoi(strsplit(profess[i,5], " ")[[1]][1])) %/% 10)
  NumRate <- NumRate+10 #number of iterations +10 just to keep it safe

  for (a in 1:NumRate)
  {
    suppressMessages(try(load_btn <- ffd$findElement(using = "css", value = ".eaZArN"), silent = TRUE))
    suppressMessages(try(load_btn$clickElement(), silent = TRUE))
    print("running")
  }

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
      courseDate[x,1] = "remove" #Sometimes coursedate repeats twice. I haven't learned HTML/CSS enough to figure out how to fix so I just rid of the adjacent duplicates
      #print(courseDate[x+1,])
      x <-  x+2
    }
    else {
      x <-  x+1
    }
  }
  freshcoursedate <- courseDate[courseDate$course != "remove",]
  
  freshcoursedate <- freshcoursedate %>% separate(date_indv, c("month", "day", "year"), " ")
  freshcoursedate <- freshcoursedate %>% separate(day, c("day"), "th,|st,|nd,|rd,")
  freshcoursedate <- freshcoursedate %>% separate(course_indv, c("course_name", "course_code"), "(?=[A-Za-z])(?<=[0-9])|(?=[0-9])(?<=[A-Za-z])")
  freshcoursedate$course_name <- substr(freshcoursedate$course_name,1,4)
  freshcoursedate$course_code <- substr(freshcoursedate$course_code,1,4)
  
  prof_name <- data.frame(profess[,1], profess[,2])
  colnames(prof_name) <- c("first_name", "last_name")
  
  professInfo = data.frame(prof_name[i,1], prof_name[i,2], freshcoursedate, quality_indv, difficulty_indv, stringsAsFactors =  FALSE, check.rows = TRUE)

  ProfnameSearch <- paste(profess[i,1], profile[i,2], "at", profess[i,8],"RateMyProfessor", sep = " ")
  CSVname <- paste(ProfnameSearch,".csv",sep = "")

  DescriptionName <- paste("Description ", ProfnameSearch,".csv",sep = "")

  write.csv(description_indv, paste('C:\\Users\\Rajat\\Desktop\\Runny\\R\\Babson\\Descriptions\\YorkU_Professors\\Descriptions\\', DescriptionName, sep = ""), row.names = FALSE) 

#Enter your destination where all description for each professor needs to be

  write.csv(professInfo, paste('C:\\Users\\Rajat\\Desktop\\Runny\\R\\Babson\\YorkU_Professors\\',CSVname, sep = ""), row.names = FALSE) 
  
#Enter your destination where the individual professor's review needs to be stored


}

