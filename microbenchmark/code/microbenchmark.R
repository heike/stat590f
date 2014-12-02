##########################################
## Test functions
##########################################
fib <- function(n) {
  if(n < 2) {
    return(n)
  } else {
    return(fib(n-1) + fib(n-2))
  }
}

rand_mat_stat <- function(t) {
  n <- 5
  stuff <- sapply(1:t, function(i){
    mat_a <- matrix(rnorm(n*n), n, n)
    mat_b <- matrix(rnorm(n*n), n, n)
    mat_c <- matrix(rnorm(n*n), n, n)
    mat_d <- matrix(rnorm(n*n), n, n)
    P <-cbind(mat_a, mat_b, mat_c, mat_d)
    Q <- rbind(cbind(mat_a, mat_b),cbind(mat_c, mat_d))
    
    c(sum(diag((t(P)%*%P)^4)), sum(diag((t(Q)%*%Q)^4)))
  })
  
  res <- apply(stuff,1,function(x) sd(x)/mean(x))
  return(res)
}


##########################################
## Time 100 runs of each function
##########################################
library(microbenchmark)

A <- matrix(1, 200, 200)
x <- rnorm(10000000)
y <- rnorm(10000000)

times <- microbenchmark(
  fib(20),
  "array_construct(200)" = matrix(1, 200, 200),
  "mat_mult(200)" = A%*%t(A),
  rand_mat_stat(1000),
  "inner(x, y)" = x%*%y
)
times <- as.data.frame(times)
times$time <- times$time*1.0e-9 #nanoseconds

#########################################
## Write results out
#########################################
write.csv(times, file="written_data/R_benchmark_times.csv", row.names=FALSE)

#########################################
# Redo inner product
#########################################
library(plyr)
sizes <- c(10, 100, 500, 1000, 5000, 10000, 100000, 1000000, 10000000)
times_inner <- mdply(sizes, function(n) {
  x <- rnorm(n)
  y <- rnorm(n)
  as.data.frame(cbind(n, microbenchmark("inner(x, y)" = x%*%y)))
})
times_inner$time <- times_inner$time*1.0e-9 #nanoseconds

write.csv(times_inner[,-1], file="written_data/R_benchmark_inner.csv", row.names=FALSE)
