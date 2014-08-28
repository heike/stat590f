using Distributions

function rmeans(dist, nobs; nsims = 500)
    means = Array(Float64,nsims)
    for i in 1:nsims
        ## Quick note here. The `@inbounds` prefix is an optional
        ## macro. My understanding is that it tells Julia that I am
        ## sure that I correctly allocated memory for the means array,
        ## so it doesn't need to check that `means[i]` is safe to
        ## write to. I know that it's safe because I allocated memory
        ## for `means` literally one line ago.
        @inbounds means[i] = mean(rand(dist, nobs))
    end
    return means
end

## Not necessary in general, but necessary if we want to time
## execution w/out compilation. We could also run
## > rmeans(Uniform(), 1)
## to force compilation w/ a short execution.
precompile(rmeans, (Uniform, Integer, Integer))

@time rmeans(Uniform(), 500);
## On Gray's 6yo laptop:
## elapsed time: 0.004002518 seconds (2036168 bytes allocated)

## Same thing but without @inbounds was:
## elapsed time: 0.004995605 seconds (2036168 bytes allocated)

@time rmeans(Uniform(), 10_000; nsims = 10_000);
## elapsed time: 2.268713373 seconds (800560256 bytes allocated, 31.13% gc time)
## w/out @inbounds:
## elapsed time: 2.349143175 seconds (800560256 bytes allocated, 35.85% gc time)

@time rmeans(Uniform(), 50_000; nsims = 50_000);
## elapsed time: 56.903345052 seconds (20002800256 bytes allocated, 31.76% gc time)
## w/out @inbouds:
## elapsed time: 63.243961707 seconds (20002800256 bytes allocated, 34.99% gc time)
## This is the only time where it makes much of a difference.

## This is starting to approach the memory limit on the machine I'm
## using. Others are encouraged to use larger numbers.
