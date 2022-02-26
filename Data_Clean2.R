library(tabulizer)  # Handy tool for PDF Scraping
library(tidyverse)  # Core data manipulation and visualization libraries
library(rvest)
library(stringr)

init_profess <- data.frame(init_name, quality, difficulty, init_num_rate, init_wouldtakeagain, course, campus,namelink, stringsAsFactors =  FALSE)

first_name <- strsplit(init_profess$init_name, split = " ", fixed=T)[1]
last_name <- strsplit(init_profess$init_name, split = " ", fixed=T)[2]
num_rating <- strsplit(init_profess$init_num_rate, split = " ", fixed=T)[[1]][1]
wouldtakeagain <- strsplit(init_profess$init_wouldtakeagain, split = "%", fixed=T)

init_profess <- init_profess %>% separate(init_name, c("first_name", "last_name"), " ")
init_profess <- init_profess %>% separate(init_num_rate, c("num_rate"), " ")
init_profess <- init_profess %>% separate(init_wouldtakeagain, c("wouldtakeagain"), "%")

profess <- data.frame(init_profess, stringsAsFactors =  FALSE)

freshcoursedate <- freshcoursedate %>% separate(date_indv, c("month", "day", "year"), " ")
freshcoursedate <- freshcoursedate %>% separate(day, c("day"), "th,|st,|nd,|rd,")
freshcoursedate <- freshcoursedate %>% separate(course_indv, c("course_name", "course_code"), "(?=[A-Za-z])(?<=[0-9])|(?=[0-9])(?<=[A-Za-z])")
freshcoursedate$course_name <- substr(freshcoursedate$course_name,1,4)
freshcoursedate$course_name <- substr(freshcoursedate$course_code,1,4)