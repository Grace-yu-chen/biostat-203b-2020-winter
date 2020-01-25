## parsing command arguments
for (arg in commandArgs(TRUE)) {
  eval(parse(text=arg))
}

## check if a given integer is prime
isPrime = function(n) {
  if (n <= 3) {
    return (TRUE)
  }
  if (any((n %% 2:floor(sqrt(n))) == 0)) {
    return (FALSE)
  }
  return (TRUE)
}

## estimate mean only using observation with prime indices
estMeanPrimes = function (x) {
  n = length(x)
  ind = sapply(1:n, isPrime)
  return (mean(x[ind]))
}

## generate seed for random number generation
set.seed (seed)

GenerateData <- function (n, dist){
  if (dist=="gaussian"){
    x=rnorm(n,mean=0)
  }
  else if (dist=="t1"){
    x=rt(n,df=1)
  }
  else if (dist=="t5"){
    x=rt(n,df=5)
  }
    return(x)
}

## calculate MSE for both method
MSEest <- c()
MSEclassic <- c()

for (i in (1:rep)) {
  x <- GenerateData(n,dist)
  Meanclassic <- mean(x)
  Meanest <- estMeanPrimes(x)
  # true mean is set as 0
  MSEclassic[i] <- (Meanclassic)^2
  MSEest[i] <- (Meanest)^2
}
MSEclassic <- mean(MSEclassic)
MSEest <- mean(MSEest)

## print out the results
cat(MSEclassic/rep,"\t", MSEest/rep)


