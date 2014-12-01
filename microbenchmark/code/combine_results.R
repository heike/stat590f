times.r <- read.csv("written_data/R_benchmark_times.csv")
times.julia <- read.csv("julia_benchmark_times.csv")
names(times.julia) <- c("expr", "time")

times.dat <- rbind(times.r, times.julia)
times.dat$lang <- c(rep("R", nrow(times.r)), rep("Julia", nrow(times.julia)))

write.csv(times.dat, file="written_data/combined_benchmark_times.csv")
