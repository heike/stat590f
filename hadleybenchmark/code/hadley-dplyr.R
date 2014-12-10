library(ggplot2)
library(plyr)
library(dplyr)
library(tidyr)
library(microbenchmark)

results <- ldply(c(1, 3, 5), function(i) {
    diamonds_new <- read.csv(paste0("data/diamonds", i, ".csv"))
    
    res1 <- microbenchmark(diamonds_new %>% group_by(cut) %>% summarise(m_depth = mean(depth),
                                                                        m_table = mean(table),
                                                                        std_depth = sd(depth),
                                                                        sd_table = sd(table)))
    
    res2 <- microbenchmark(sample_n(diamonds_new, ceiling(0.2 * nrow(diamonds_new))))
    
    res3 <- microbenchmark(diamonds_new %>% gather(variable, value, x:z))
    
    return(c(summarise = median(res1$time / 1000000), sample = median(res2$time / 1000000), tidy = median(res3$time / 1000000)))
})
results$size <- c(1, 3, 5)
write.csv(results, "output/dplyr-results.csv", row.names = FALSE)
