library(ggplot2)
library(plyr)
library(reshape2)
library(microbenchmark)

results <- ldply(c(1, 3, 5), function(i) {
    diamonds_new <- read.csv(paste0("data/diamonds", i, ".csv"))
    
    res1 <- microbenchmark(ddply(diamonds_new, .(cut), summarise, m_depth = mean(depth),
                                 m_table = mean(table),
                                 std_depth = sd(depth),
                                 sd_table = sd(table)))
    
    res2 <-microbenchmark(diamonds_new[sample(1:nrow(diamonds_new), ceiling(0.2 * nrow(diamonds_new))), ])
    
    res3 <- microbenchmark(melt(diamonds_new, measure.vars = 8:10))
    
    return(c(summarise = median(res1$time / 1000000), sample = median(res2$time / 1000000), tidy = median(res3$time / 1000000)))
})
results$size <- c(1, 3, 5)
write.csv(results, "output/plyr-results.csv", row.names = FALSE)

