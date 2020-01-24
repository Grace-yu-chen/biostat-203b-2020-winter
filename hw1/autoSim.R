# autoSim.R

## parsing command arguments
for (arg in commandArgs(TRUE)) {
  eval(parse(text=arg))
}

# call R
nVals <- seq(100, 500, by=100)
distTypes = c("gaussian", "t1", "t5")
for (dist in distTypes){
  for (n in nVals) {
    oFile <- paste("n", n,"dist",dist, ".txt", sep="")
    arg = paste("n=", n, " dist=", shQuote(shQuote(dist)),
                " seed=", seed, " rep=", rep)
    sysCall = paste("nohup Rscript runSim.R ", arg, " > ", oFile, sep="")
    system(sysCall, wait = FALSE)
    print(paste("sysCall=", sysCall, sep=""))
  }
}