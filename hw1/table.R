results <- c() 
N <- c()
nVals <- seq(100, 500, by=100)
distTypes = c("gaussian", "t1", "t5")
for (dist in distTypes) {
  for (n in nVals){
    oFile <- paste("/home/chenyu1997/biostat-203b-2020-winter/hw1/n_",n,
                      "_dist_",dist, ".txt", sep="")
    Tresults <- read.table(oFile)
    Tresults <- Tresults[,2]
    results <- c(results,Tresults)
    N <- c(N,rep(n,2))
  }
}
N <- N[1:10]
# the second coloumn for the table
Method <- rep(c('PrimeAvg','SampAvg'),5)
# build a table to display results
results_table <- data.frame(n=N,Method=Method,Gaussian=results[1:10],t_1=results[11:20],
                            t_5=results[21:30])
print(results_table)
