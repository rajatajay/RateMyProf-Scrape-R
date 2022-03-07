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


## Update March 5th 2022

Cleaned all the possible data all sorted in alphabetic order

![](https://i.imgur.com/mxKTH1z.png)

After processing the data, I was able to vislualize into Tableau time-series scatter plot of average difficulty and quality scores by catergorizing into [1000 Level](https://public.tableau.com/app/profile/rajat.ajay/viz/1000LevelCourses/Dashboard1), [2000 Level](https://public.tableau.com/app/profile/rajat.ajay/viz/2000LevelCourses/Dashboard1), [3000 Level](https://public.tableau.com/app/profile/rajat.ajay/viz/3000LevelCourses/Dashboard1), and [4000 Level](https://public.tableau.com/app/profile/rajat.ajay/viz/4000LevelCourses/Dashboard1) Courses. Moreover interesting insights on [Monthly Reviews of ECON Courses](https://public.tableau.com/app/profile/rajat.ajay/viz/MonthlyECONLevelCourses/Dashboard1) were provided as well.

More data-processing is required for course codes and course names as some values were switched. Once the minor changes are made, the file should be ready for more Tableau Data Visualization.


### Additional Changes and/or notes

* Scraping time usually depends on the PC, I've averaged at 180 minutes

