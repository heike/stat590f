rstats <- function(rerror, nobs, nsims = 500) {
  replicate(nsims, mean(rerror(nobs)))}

system.time(rstats(runif, 500))
## On Gray's machine:
##    user  system elapsed 
##   0.033   0.000   0.033

## One point I'm confused about: this is running about 10x faster than
## when I ran the same code (on the same computer) in February.

system.time(rstats(runif, 10000, 10000))
##    user  system elapsed 
##   8.325   0.535   8.860 

system.time(rstats(runif, 50000, 50000))
##    user  system elapsed 
## 209.138  12.025 221.216

## For larger n, it runs at about the same speed as in February.
