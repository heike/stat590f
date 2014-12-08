library(dplyr)

times.julia <- read.csv("julia_benchmark_times.csv")
names(times.julia) <- c("expr", "time")

times.julia %>% group_by(expr) %>% summarise(time = mean(time))
