times.r <- read.csv("written_data/R_benchmark_times.csv")
times.julia <- read.csv("written_data/julia_benchmark_times.csv")
names(times.julia) <- c("expr", "time")

times.dat <- rbind(times.r, times.julia)
times.dat$lang <- c(rep("R", nrow(times.r)), rep("Julia", nrow(times.julia)))

write.csv(times.dat, file="written_data/combined_benchmark_times.csv")

times_inner.r <- read.csv("written_data/R_benchmark_inner.csv")
times_inner.julia <- read.csv("written_data/julia_benchmark_inner.csv")
names(times_inner.julia) <- c("n", "expr", "time")

times_inner.dat <- rbind(times_inner.r, times_inner.julia)
times_inner.dat$lang <- c(rep("R", nrow(times_inner.r)), rep("Julia", nrow(times_inner.julia)))

write.csv(times_inner.dat, file="written_data/combined_benchmark_inner.csv")
