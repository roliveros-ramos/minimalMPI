
RLIB = "~/R/x86_64-pc-linux-gnu-library/3.2"

install.packages("source/doMPI_0.2.2.tar.gz", type="source", 
                 lib = RLIB)

library(doMPI, lib.loc = RLIB)

cl = startMPIcluster()
registerDoMPI(cl)
np = 28

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
