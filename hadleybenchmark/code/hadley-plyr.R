library(ggplot2)
library(plyr)
library(reshape2)
library(microbenchmark)

hadleybench_plyr <- function(repeat_rows = 1) {
    diamonds_new <- eval(parse(text = paste0("rbind(", paste(rep("diamonds", repeat_rows), collapse = ", "), ")")))
    
    res1 <- microbenchmark(ddply(diamonds_new, .(cut), summarise, m_depth = mean(depth),
                                 m_table = mean(table),
                                 std_depth = sd(depth),
                                 sd_table = sd(table)))
    
    res2 <-microbenchmark(diamonds_new[sample(1:nrow(diamonds_new), ceiling(0.2 * nrow(diamonds_new))), ])
    
    res3 <- microbenchmark(melt(diamonds_new, measure.vars = 8:10))
    
    return(c(median(res1$time / 1000000), median(res2$time / 1000000), median(res3$time / 1000000)))
}

