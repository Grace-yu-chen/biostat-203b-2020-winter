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

MSEclassic <- 0
MSEest <- 0
for (r in 1:rep){
  if (dist=="gaussian"){
    x=rnorm(n)
  }
  else if (dist=="t1"){
    x=rt(n,df=1)
  }
  else if (dist=="t5"){
    x=rt(n,df=5)
  }
  else{
    stop("unrecognized distribution")
  }
  ## calculate MSE for both method
  MSEclassic <- MSEclassic + mean(x)^2
  MSEest <- MSEest + estMeanPrimes(x)^2
}

## print out the results
cat(MSEclassic/rep,"\t", MSEest/rep)


