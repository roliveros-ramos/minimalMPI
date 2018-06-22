library(doMPI)

cl = startMPIcluster()
registerDoMPI(cl)
np = 56

wd = getwd()

if(!dir.exists("scratch")) dir.create("scratch")

out = foreach(i=1:(np-1), .combine = cbind) %dopar% {
  
  setwd(wd) # back to current directory in the slave
  tmp = runif(42)
  write.csv(tmp, file=file.path("scratch", 
                                sprintf("output%02d.csv", i)))
  tmp # last value is returned
  
} # end of foreach loop

save(out, file="mpiTest.rda")

closeCluster(cl)
mpi.quit()
