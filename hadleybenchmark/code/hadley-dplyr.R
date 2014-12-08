library(ggplot2)
library(dplyr)
library(tidyr)
library(microbenchmark)

hadleybench_dplyr <- function(repeat_rows = 1) {
    diamonds_new <- eval(parse(text = paste0("rbind(", paste(rep("diamonds", repeat_rows), collapse = ", "), ")")))
    
    res1 <- microbenchmark(diamonds_new %>% group_by(cut) %>% summarise(m_depth = mean(depth),
                                                                        m_table = mean(table),
                                                                        std_depth = sd(depth),
                                                                        sd_table = sd(table)))
    
    res2 <- microbenchmark(sample_n(diamonds_new, ceiling(0.2 * nrow(diamonds_new))))
    
    res3 <- microbenchmark(diamonds_new %>% gather(variable, value, x:z))
    
    return(c(median(res1$time / 1000000), median(res2$time / 1000000), median(res3$time / 1000000)))
}
