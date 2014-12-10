library(dplyr)
library(reshape2)
library(ggplot2)

times.julia1 <- read.csv("output/julia_benchmark_times1.csv", header = FALSE)
times.julia3 <- read.csv("output/julia_benchmark_times3.csv", header = FALSE)
times.julia5 <- read.csv("output/julia_benchmark_times5.csv", header = FALSE)

times.julia <- rbind(times.julia1, times.julia3, times.julia5)

names(times.julia) <- c("variable", "value")
times.julia$size <- rep(c(1, 3, 5), each = nrow(times.julia1))

julia.results <- times.julia %>% group_by(variable, size) %>% summarise(value = median(value))

plyr.results <- read.csv("output/plyr-results.csv")
plyr.melt <- melt(plyr.results, id.vars = 4)
plyr.melt$value <- plyr.melt$value / 1000

dplyr.results <- read.csv("output/dplyr-results.csv")
dplyr.melt <- melt(dplyr.results, id.vars = 4)
dplyr.melt$value <- dplyr.melt$value / 1000

final.results <- rbind(julia.results, plyr.melt, dplyr.melt)
final.results$type <- rep(c("julia", "plyr", "dplyr"), each = nrow(julia.results))

qplot(size, value, data = final.results, geom = "line", group = type, colour = type, facets = variable~.) + geom_point()
qplot(size, value, data = subset(final.results, variable != "tidy"), geom = "line", group = type, colour = type, facets = variable~.) + geom_point()
