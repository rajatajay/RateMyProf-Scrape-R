library(tidyverse)
library(plyr)
setwd("C:\\Users\\Rajat\\Desktop\\Runny\\R\\YorkUKeeleFinalTest")

for (i in 1:length(list.files())){
  
  df <- read.csv(list.files()[i])
  print(i)
  first_name <- strsplit(list.files()[i], " ")[[1]][1]
  last_name <- strsplit(list.files()[i], " ")[[1]][2]
  
  if("date_indv" %in% colnames(df))
  {
    if (length(df) > 0){
      df$first_name <- first_name
      df$last_name <- last_name
      df <- df[, c(5, 6, 1, 2, 3, 4)]
      df <- df %>% separate(date_indv, c("month", "day", "year"), " ")
      df <- df %>% separate(day, c("day"), "th,|st,|nd,|rd,")
      df <- df %>% separate(course_indv, c("course_name", "course_code"), "(?=[A-Za-z])(?<=[0-9])|(?=[0-9])(?<=[A-Za-z])")
      df$course_name <- substr(df$course_name,1,5)
      df$course_code <- substr(df$course_code,1,4)
      
      write.csv(df, paste("C:\\Users\\Rajat\\Desktop\\Runny\\R\\YorkUKeeleFinalTest\\", list.files()[i], sep = ""), row.names = FALSE)
    }
  }
  else{
    df <- read.csv(list.files()[i])
    df$first_name <- first_name
    df$last_name <- last_name
    df <- df[, c(5, 6, 1, 2, 3, 4)]
    df <- df %>% separate(date, c("month", "day", "year"), " ")
    df <- df %>% separate(day, c("day"), "th,|st,|nd,|rd,")
    df <- df %>% separate(course, c("course_name", "course_code"), "(?=[A-Za-z])(?<=[0-9])|(?=[0-9])(?<=[A-Za-z])")
    df$course_name <- substr(df$course_name,1,5)
    df$course_code <- substr(df$course_code,1,4)
    
    write.csv(df, paste("C:\\Users\\Rajat\\Desktop\\Runny\\R\\YorkUKeeleFinalTest\\", list.files()[i], sep = ""), row.names = FALSE)
  }
}


dataset <- ldply(list.files(), read.csv, header=TRUE)
dff <- as.data.frame(dataset)


data_blank <- sapply(dff, as.character) 
data_blank[is.na(data_blank)] <- ""

dff2 <- as.data.frame(data_blank)

dff2$quality_indv <- paste(dff2$quality_indv, dff2$quality)
dff2$difficulty_indv <- paste(dff2$difficulty_indv, dff2$difficulty)

dff2 <- dff2[, -c(10:14)] 

dff2$quality_indv <- as.numeric(as.character(dff2$quality_indv))
dff2$difficulty_indv <- as.numeric(as.character(dff2$difficulty_indv))
dff2$course_code <- as.numeric(as.character(dff2$course_code))
dff2$day <- as.numeric(as.character(dff2$day))
dff2$year <- as.numeric(as.character(dff2$year))

write.csv(dff2, file = "C:\\Users\\Rajat\\Desktop\\Runny\\R\\CleanYorkU4.csv", row.names = FALSE)