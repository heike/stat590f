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

##########################################
## Test functions
##########################################
function fib(n) 
	n < 2 ? n : fib(n-1) + fib(n-2)
end

function array_construct(n)
	ones(n, n)
end

function mat_mult(n) 
	A = array_construct(n);
	A*A'
end

function rand_mat_stat(t)
    n = 5
    v = zeros(t)
    w = zeros(t)
    for i=1:t
        a = randn(n,n)
        b = randn(n,n)
        c = randn(n,n)
        d = randn(n,n)
        P = [a b c d]
        Q = [a b; c d]
        v[i] = trace((P.'*P)^4)
        w[i] = trace((Q.'*Q)^4)
    end
    return (std(v)/mean(v), std(w)/mean(w))
end

function inner(x, y)
    result = 0.0
    for i=1:length(x)
        result += x[i] * y[i]
    end
    result
end

##########################################
## Initialize all functions
##########################################
fib(1)
array_construct(20)
mat_mult(20)
rand_mat_stat(20)

x = randn(10); y = randn(10)
inner(x, y)

##########################################
## Time 100 runs of each function
##########################################
x = randn(10000000)
y = randn(10000000)

times = Array(Any, 0, 2);
for i=1:100 
	times = [times, ["fib(20)" @time_it fib(20)]]; 
	times = [times, ["array_construct(200)" @time_it array_construct(200)]];
	times = [times, ["mat_mult(200)" @time_it mat_mult(200)]];
	times = [times, ["rand_mat_stat(1000)" @time_it rand_mat_stat(1000)]];
	times = [times, ["inner(x, y)" @time_it inner(x, y)]];
end

#########################################
## Write results out
#########################################
writecsv("written_data/julia_benchmark_times.csv", times)

#########################################
# Redo inner product
#########################################
sizes = [10 100 500 1000 5000 10000 100000 1000000 10000000];
times_inner = Array(Any, 0, 3);
for n = sizes
  for i=1:100 
    x = randn(n)
    y = randn(n)
    times_inner = [times_inner, [n "inner(x, y)" @time_it inner(x, y)]];
  end
end

writecsv("written_data/julia_benchmark_inner.csv", times_inner)

