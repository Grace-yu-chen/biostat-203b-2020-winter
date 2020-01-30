*Yu Chen*

### Overall Grade: 94/110

### Quality of report: 10/10

-   Is the homework submitted (git tag time) before deadline? 

    Yes. `Jan 24, 2020, 10:35 PM PST`.

-   Is the final report in a human readable format html? 

    Yes. `html` file. 

-   Is the report prepared as a dynamic document (R markdown) for better reproducibility?

    Yes. `Rmd`.

-   Is the report clear (whole sentences, typos, grammar)? Do readers have a clear idea what's going on and how are results produced by just reading the report? 

	  Yes.   


### Correctness and efficiency of solution: 49/60

-   Q1 (10/10)

-   Q2 (15/20)

    \#3. (-3 pts) Display the number of lines in each `csv` file. 
    
    \#4. (-2 pts) Your solution (shown below) counts the number of occurrences `HISPANIC` in the file. 
       ```
       grep -o 'HISPANIC' /home/203bdata/mimic-iii/ADMISSIONS.csv | wc -l
       ```
       
       But the question asks for the number of **unique** Hispanic patients. Count the number of Hispanic patients with unique `SUBJECT_ID`.
    
-   Q3 (12/15)

    \#3. (-3 pts) Explain the output. Explain the meaning of `"$1"`, `"$2"`, and `"$3"` in this shell script.

-   Q4 (12/15)

	  \#3. (-3 pts)
	  
    - Values in the table do not match the results in output files. 
    - Table looks crude. Use `kable` to print the table in the given format. 
	
	    
### Usage of Git: 10/10

-   Are branches (`master` and `develop`) correctly set up? Is the hw submission put into the `master` branch? 

    Yes. 

-   Are there enough commits? Are commit messages clear? 

    22 commits for hw1. 

          
-   Is the hw1 submission tagged? 

    Yes. `hw1`. 

-   Are the folders (`hw1`, `hw2`, ...) created correctly? 

    Yes.
  
-   Do not put a lot auxiliary files into version control. 

	  Yes. 
	  
### Reproducibility: 8/10

-   Are the materials (files and instructions) submitted to the `master` branch sufficient for reproducing all the results? Just click the `knit` button will produce the final `html` on teaching server? (-2 pts)

	  Clicking the `knit` button does not produce the final `html` on the teaching server. 
	  - You need to `eval=TRUE` for the following code chunk since `price_and_prejudice.txt` is not in version control. Otherwise, I won't be able to run your code. 
	  ````
      ```{bash, eval=TRUE}
        curl http://www.gutenberg.org/cache/epub/42671/pg42671.txt > pride_and_prejudice.txt
      ```
    ````
    - The path `/home/chenyu1997/pride_and_prejudice.txt` under Q3 in `hw1sol.Rmd` and `"/home/chenyu1997/biostat-203b-2020-winter/hw1/n_"` in `table.R` are for your own directory on the server. Use relative path for easier reproducibility. For example, simply use the following since `price_and_prejudice.txt` (downloaded using `curl` command) would be in your current directory. 
    
    ````
      ```{bash}
       for namei in Elizabeth Jane Lydia Darcy
       do
        echo $namei
        grep -o $namei pride_and_prejudice.txt | wc -l
        echo
       done
      ```
    ````
-   If necessary, are there clear instructions, either in report or in a separate file, how to reproduce the results?

    Yes.

### R code style: 17/20

-   [Rule 3.](https://google.github.io/styleguide/Rguide.xml#linelength) The maximum line length is 80 characters. (-1 pt)

    Some violations:
      - `table.R`: line 19 

-   [Rule 4.](https://google.github.io/styleguide/Rguide.xml#indentation) When indenting your code, use two spaces.

-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Place spaces around all binary operators (=, +, -, &lt;-, etc.). 	
	
-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Do not place a space before a comma, but always place one after a comma. (-2 pts)

    Some violations:
      - `autoSim.R`: lines 13, 16
      - `runSim.R`: lines 34, 37
      - `table.R`: lines 8, 12, 17, 19

-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Place a space before left parenthesis, except in a function call.

-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Do not place spaces around code in parentheses or square brackets.
