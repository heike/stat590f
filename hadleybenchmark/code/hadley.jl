using DataFrames, RDatasets

# cd("$(homedir())/GitHub/stat590f/hadleybenchmark")
# econ = readtable("data/economical-status-cleaned-full.csv") # don't use readcsv!

# diamonds = dataset("ggplot2", "diamonds")

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

diamonds = readtable("data/diamonds1.csv")

times = Array(Any, 0, 2);
for i=1:100
    times = [times, ["summarise" @time_it by(diamonds, :cut) do df
    DataFrame(m_depth = mean(df[:depth]),
		  m_table = mean(df[:table]),
		  std_depth = std(df[:depth]), 
	          std_table = std(df[:table]))
end]]; 
	times = [times, ["sample" @time_it diamonds[sample(1:size(diamonds, 1), iceil(0.2 * size(diamonds, 1))), :]]]; 
	times = [times, ["tidy" @time_it stack(diamonds, 8:10)]]; 
end

writecsv("output/julia_benchmark_times1.csv", times)

diamonds = readtable("data/diamonds3.csv")

times = Array(Any, 0, 2);
for i=1:100
    times = [times, ["summarise" @time_it by(diamonds, :cut) do df
    DataFrame(m_depth = mean(df[:depth]),
		  m_table = mean(df[:table]),
		  std_depth = std(df[:depth]), 
	          std_table = std(df[:table]))
end]]; 
	times = [times, ["sample" @time_it diamonds[sample(1:size(diamonds, 1), iceil(0.2 * size(diamonds, 1))), :]]]; 
	times = [times, ["tidy" @time_it stack(diamonds, 8:10)]]; 
end

writecsv("output/julia_benchmark_times3.csv", times)

diamonds = readtable("data/diamonds5.csv")

times = Array(Any, 0, 2);
for i=1:100
    times = [times, ["summarise" @time_it by(diamonds, :cut) do df
	DataFrame(m_depth = mean(df[:depth]),
		  m_table = mean(df[:table]),
		  std_depth = std(df[:depth]), 
	          std_table = std(df[:table]))
end]]; 
	times = [times, ["sample" @time_it diamonds[sample(1:size(diamonds, 1), iceil(0.2 * size(diamonds, 1))), :]]]; 
	times = [times, ["tidy" @time_it stack(diamonds, 8:10)]]; 
end

writecsv("output/julia_benchmark_times5.csv", times)


