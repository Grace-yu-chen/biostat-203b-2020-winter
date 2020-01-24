## read MSEs from txt files and built a vector to save them
# nVals <- seq(100, 500, by=100)
# distTypes = c("gaussian", "t1", "t5")
# results <- c() 
# N <- c() # the first coloumn of the table
# for (dist in distTypes) {
#   for (n in nVals){
#     oFile <- paste("n",n,"dist",dist, ".txt", sep="")
#     Tableresults <- read.table(oFile)
#     Tableresults <- Tableresults[,2]
#     results <- c(results,Tableresults)
#     N <- c(N,rep(n,2))
#   }
# }
# N <- N[1:10]
# ## the 2nd coloumn for the table
# Method <- rep(c('PrimeAvg','SampAvg'),5)


N <- c()
nVals <- seq(100, 500, by=100)
distTypes = c("gaussian", "t1", "t5")
for (dist in distTypes){
  for (n in nVals) {
    filename <- paste("n_",n,"_dist_",dist,".txt",sep="")
    datalist <- read.table(filename)
    # the first coloumn of the table
    N <- c(N, rep(n,2))
  }
}
# the second coloumn for the table
Method <- rep(c('PrimeAvg','SampAvg'),each=5)
## built a table to display results
table <- data.frame(n=N, Method=Method, Gaussian=datalist[1:10], t_5=datalist[21:30], t_1=datalist[11:20])
print(table)
