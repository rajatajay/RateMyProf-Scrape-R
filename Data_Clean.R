library(tidyverse)


NumberRating = "10 ratings"
Name <-  "Jau Rao"
Name2 = ". Ristuccia"
Take_Again = "34%"

Course = " MKTG1030" #do check if with ten rows, see if it's 4 word code or three word code, convert it accordingly to split between strings and numbers

Course2 = " MARKETRESEARCH"
Course3 = " IME1"
Course4 = "71880"
Course5 = " FME1000ECON03"
Date = "May 26th, 2018"

take_again_percentage <- strsplit(Take_Again, split = "%", fixed=T)
num_rating <- strsplit(NumberRating, split = " ", fixed=T)[[1]][1]

first_name <- strsplit(Name, split = " ", fixed=T)[[1]][1]
last_name <- strsplit(Name, split = " ", fixed=T)[[1]][2]

date_c <- strsplit(Date, split = " " , fixed=T)
month <- date_c[[1]][1]
day <- strsplit(date_c[[1]][2],split="th,|st,|nd,|rd,")
year <- date_c[[1]][3]

#course_sep <- strsplit(Course5,split="(?<=[a-zA-Z])\\s*(?=[0-9])",perl=TRUE) #only for testing
course_sep <- strsplit(Course5, "(?=[A-Za-z])(?<=[0-9])|(?=[0-9])(?<=[A-Za-z])", perl=TRUE)

if (lengths(course_sep) == 1)
{
  check_int <- strtoi(course_sep[[1]][1])
  if (is.na(check_int)){
    course_code_name <- abbreviate(course_sep[[1]][1], minlength = 4)
  }
  else{
    course_code_num <- abbreviate(course_sep[[1]][1], minlength = 4)
  }
}else{
  course_code_name <- abbreviate(course_sep[[1]][1], minlength = 4)
  course_code_num <- abbreviate(course_sep[[1]][2], minlength = 4)
}
