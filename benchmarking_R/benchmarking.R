timeit <- function(f, ..., times=100) {
  times <- sapply(1:times, function(x){
    system.time(f(...))["elapsed"]
  })
  return(times)
}

fib <- function(n) {
  if(n < 2) {
    return(n)
  } else {
    return(fib(n-1) + fib(n-2))
  }
}


library(microbenchmark)

n <- 20

bench <- microbenchmark(
  matrix(1, n, n),
  fib(n)
)

library(ggplot2)
qplot(expr, time, data=bench, geom="boxplot")

#timeit(fib, 20)
