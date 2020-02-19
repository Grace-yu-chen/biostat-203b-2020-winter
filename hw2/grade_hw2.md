*Yu Chen* 

### Overall Grade: 93/100

### Quality of report: 10/10

-   Is the homework submitted (git tag time) before deadline?

    Yes. `Feb 7, 2020, 7:04 PM PST`.

-   Is the final report in a human readable format html?

    Yes, `html`.

-   Is the report prepared as a dynamic document (R markdown) for better reproducibility?

    Yes. `Rmd`.

-   Is the report clear (whole sentences, typos, grammar)? Do readers have a clear idea what's going on and how are results produced by just reading the report?

    Yes. 

### Correctness and efficiency of solution: 45/50

-   Q1 (18/20) (-2 pts) Did not summarize variables death and number of admissions per patient using *appropriate graphs*. 
    
-   Q2 (10/10)
   

-   Q3 (10/10)

-   Q4 (7/10) (-3 pts)
    - To get the systolic blood measurement, match values from `ITEMID` in `chartevents` with the values obtained from `D_ITEMS.csv` through `filter(D_items, grepl("systolic", LABEL))`. 
    - We want to get **the first ICU stay** of unique patients, not just unique patients. Your code below only extracts unique patients from `chartevents`.  
      ```
      chartevents2 <- distinct(chartevents, SUBJECT_ID, .keep_all = TRUE)
      ```
      One idea is to `group_by` SUBJECT_ID in `ICUSTAYS`, arrange by their `INTIME` in `ICUSTAYS` and get their first stay.
    - Include explanation in your own words. 

### Usage of Git: 10/10

-   Are branches (`master` and `develop`) correctly set up? Is the hw submission put into the `master` branch?

    Yes.

-   Are there enough commits? Are commit messages clear? 

    10 commits on `develop` for hw2. 
    
    
- 	Is the hw2 submission tagged? 

	  Yes. 

-   Are the folders (`hw1`, `hw2`, ...) created correctly?

    Yes.

-   Do not put a lot auxillary files into version control.

    Yes.

### Reproducibility: 10/10

-   Are the materials (files and instructions) submitted to the `master` branch sufficient for reproducing all the results? 

    Yes. 

-   If necessary, are there clear instructions, either in report or in a separate file, how to reproduce the results?

    Yes.


### R code style: 18/20

-   [Rule 2.5](https://style.tidyverse.org/syntax.html#long-lines): Strive to limit your code to 80 characters per line. This fits comfortably on a printed page with a reasonably sized font. (-2 pts)

    Some violations:
      - `hw2sol.Rmd`: lines 96, 105, 231, 243, 384, 385, 393

-   [Rule 2.4](https://style.tidyverse.org/syntax.html#indenting): 2 spaces for indenting.

-   [Rule 2.2](https://style.tidyverse.org/syntax.html#infix-operators): Most infix operators (`==`, `+`, `-`, `<-`, etc.) should always be surrounded by spaces. 

-   [Rule 2.2](https://style.tidyverse.org/syntax.html#commas): Always place a space after a comma, never before, just like in regular English. 


-   [Rule 2.2](https://style.tidyverse.org/syntax.html#parentheses): Place a space before left parenthesis, except in a function call. Do not place spaces around code in parentheses or square brackets. Exception: Always place a space after a comma.