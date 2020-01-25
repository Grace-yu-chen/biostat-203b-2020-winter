datalist <- c()
data <- c()
N <- c()
nVals <- seq(100, 500, by=100)
distTypes = c("gaussian", "t1", "t5")
for (dist in distTypes){
  for (n in nVals) {
    filename <- paste("/home/chenyu1997/biostat-203b-2020-winter/hw1/n_",n,
                      "_dist_",dist, ".txt", sep="")
    datalist <- read.table(filename)
    datalist <- datalist[,2]
    data <- c(data,datalist)
    # the first coloumn of the table
    N <- c(N, rep(n,2))
  }
}
N <- N[1:10]
# the second coloumn for the table
Method <- rep(c('PrimeAvg','SampAvg'),5)
# build a table to display results
table <- data.frame(n=N,Method=Method,Gaussian=data[1:10],t_5=data[21:30],t_1=data[11:20])
print(table)
