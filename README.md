# RateMyProf Scraping Tool

## Brief Description

Scrapes all professor's review data from RateMyProf.com, as well as individual reviews. Only the University link is required to be uploaded.

## Output

There will be two outputs;

#### Output 1

All the brief review of all the professors in the provided University Page Link. For example here is the result of Babson College's Brief Professor Review in a CSV file:

![](https://i.imgur.com/nmsI4d6.png)

#### Output 2

All the reviews of individual professors. I separately appended all of them in a single CSV file:

![](https://i.imgur.com/Rb74POt.png)

**Columns 'course_indv', 'date_indv', 'quality_indv', 'difficulty_indv' are the only ones from the R Script. All other columns were created through Pandas. I will make futher changes to specifically create the other columns in R**

#### Output 1 Code Description



