# RateMyProf Scraping Tool

## Brief Description

Scrapes all professor's review data from RateMyProf.com, as well as individual reviews. Only the University link is required to be uploaded.

## Output

There will be two outputs;

### Output 1

All the brief review of all the professors in the provided University Page Link. For example here is the result of Babson College's Brief Professor Review in a CSV file:

![](https://i.imgur.com/nmsI4d6.png)

### Output 2

All the reviews of individual professors. I separately appended all of them in a single CSV file:

![](https://i.imgur.com/Rb74POt.png)

**Columns 'course_indv', 'date_indv', 'quality_indv', 'difficulty_indv' are the only ones from the R Script. All other columns were created through Pandas. I will make futher changes to specifically create the other columns in R**

### Output 1 Code 

```
eCaps <- list(chromeOptions = list(
  args = c('--headless', '--disable-gpu', '--window-size=1280,800')
))

rd <- rsDriver(extraCapabilities = eCaps) #Running headless chrome
ffd <- rd$client
ffd$navigate("https://www.ratemyprofessors.com/search/teachers?query=*&sid=73") #Currently entered Babson College, US
ffd$screenshot(display = TRUE) #Just to check if you've got the right page

Sys.sleep(2)

load_btn <- ffd$findElement(using = "css", value = ".ecgEHi") #To get rid of the pop-up
load_btn$clickElement()

check <- 1

while (check == 1)
{
  load_btn <- ffd$findElement(using = "css", value = ".eaZArN")
  #page = read_html(ffd$getPageSource()[[1]])
  load_btn$clickElement() #To press show more
  Sys.sleep(10)
}
# It will eventually move on after reaching the end of the page

page = read_html(ffd$getPageSource()[[1]]) # Reads the entire page 

name = page %>% html_nodes(".cJdVEK") %>% html_text()
quality = page %>% html_nodes(".CardNumRating__CardNumRatingNumber-sc-17t4b9u-2") %>% html_text()
difficulty = page %>% html_nodes(".enhFnm+ .fyKbws .hroXqf") %>% html_text()
noRate = page %>% html_nodes(".jMRwbg") %>% html_text()
wouldtakeagain = page %>% html_nodes(".fyKbws:nth-child(1) .hroXqf") %>% html_text()
course = page %>% html_nodes(".haUIRO") %>% html_text()
campus = page %>% html_nodes(".iDlVGM") %>% html_text()

namelink <- page %>% html_nodes(".dLJIlx") %>% html_attr("href") %>% paste("https://www.ratemyprofessors.com", ., sep = "") 


profess = data.frame(name, quality, difficulty, noRate, wouldtakeagain, course, campus,namelink, stringsAsFactors =  FALSE)

write.csv(profess, "BabsonCollege.csv") #change uni name each time
```

### Output 2 Code

> ```
profile <- data.frame(namelink, name)

for (i in 1:nrow(profile)) {

  ffd$navigate(paste('',profile[i,1],'',sep = ""))

  suppressMessages(try(load_btn <- ffd$findElement(using = "css", value = ".ecgEHi"), silent = TRUE)) #To get rid of the pop-up
  suppressMessages(try(load_btn$clickElement(), silent = TRUE))

  NumRate <- 0
  NumRate <- ((strtoi(strsplit(profess[i,4], " ")[[1]][1])) %/% 10)
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

  professInfo = data.frame(freshcoursedate, quality_indv, difficulty_indv, stringsAsFactors =  FALSE, check.rows = TRUE)

  ProfnameSearch <- paste(profess[i,1], "at", profess[i,7],"RateMyProfessor", sep = " ")
  CSVname <- paste(ProfnameSearch,".csv",sep = "")

  DescriptionName <- paste("Description ", ProfnameSearch,".csv",sep = "")

  write.csv(description_indv, paste('C:\\Users\\Rajat\\Desktop\\Runny\\R\\Babson\\Descriptions\\', DescriptionName, sep = ""), row.names = FALSE) #Enter your destination where all description for each professor needs to be

  write.csv(professInfo, paste('C:\\Users\\Rajat\\Desktop\\Runny\\R\\Babson\\',CSVname, sep = ""), row.names = FALSE) #Enter your destination where the individual professor's review needs to be stored
```

### Additional Changes and/or notes

* Scraping time usually depends on the PC, I've averaged at 180 minutes
* I need to add more data wrangling and data-scraping to make it look prettier
* This is not the final build, however, I will make changes in the coming days