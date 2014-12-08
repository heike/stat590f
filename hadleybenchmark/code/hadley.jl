using DataFrames, RDatasets

# cd("$(homedir())/GitHub/stat590f/hadleybenchmark")
# econ = readtable("data/economical-status-cleaned-full.csv") # don't use readcsv!

diamonds = dataset("ggplot2", "diamonds")

##########################################
## Util for timing
##########################################
macro time_it(ex)
  quote
    local t0 = time()
    local val = $ex
    local t1 = time()
    t1-t0
  end
end

times = Array(Any, 0, 2);
for i=1:1000 
	times = [times, ["summarise" @time_it by(diamonds, :Cut) do df
	DataFrame(m_depth = mean(df[:Depth]),
		  m_table = mean(df[:Table]),
		  std_depth = std(df[:Depth]), 
	          std_table = std(df[:Table]))
end]]; 
	times = [times, ["sample" @time_it diamonds[sample(1:size(diamonds, 1), iceil(0.2 * size(diamonds, 1))), :]]]; 
	times = [times, ["tidy" @time_it stack(diamonds, 8:10)]]; 
end

writecsv("julia_benchmark_times.csv", times)


