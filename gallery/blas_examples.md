*The general idea*: use BLAS functions, and especially mutating BLAS
fuctions, where possible.

[From the Julia-users mailing list][0] (the question was asked by a friend
of mine from grad school...), how to calculate the crossproducts
   X_1'X_1,  X_2'*X_2, ..., X_N'X_N, where X_i = X[find(cl.==i),:]. 

with the initial code
```.jl
    function block_crossprod!(out, X, cl)
        for j in unique(cl)
           out[:,:] += X[find(cl.==j),:]'*X[find(cl.==j),:]
        end
    end
```
(We'll assume that we might want to do a weighted sum of the blocks,
or we speed this up by disregarding the blocks entirely and just
indexing the rows all at once.)

We can speed this up with the [BLAS function "syrk!"][1]
```.jl
function block_crossprod2!(out, X, cl)
    for j in unique(cl)
        Base.BLAS.syrk!('U', 'T', 1., X[cl .== j,:], 1., out)
    end
end
```
`out` will only contain the upper triangular part, but `Symmetric(out)`
will make it symmetric.

If we know more about the indexing scheme, we can improve things even
more by replacing X[cl .== j,:] with a subarray:
```.jl
function block_crossprod3!(out, X, bstarts, blengths)
    for j in 1:length(bstarts)
        Base.BLAS.syrk!('U', 'T', 1.,
            sub(X, range(bstarts[j], blengths[j]),:), 1., out)
    end
end
```

Finally, we can get a marginal speedup if we can set up the problem to
[work with columns of X][2], so we'll be accessing contiguous spots in
memory. Note that we need to change the second argument of `syrk!` as
well as switch the indices in X.
```.jl
function colwise_crossprod2!(out, X, cl)
    for j in unique(cl)
        Base.BLAS.syrk!('U', 'N', 1., X[:,cl .== j], 1., out)
    end
end

function colwise_crossprod3!(out, X, bstarts, blengths)
    for j in 1:length(bstarts)
        Base.BLAS.syrk!('U', 'N', 1.,
            sub(X, :, range(bstarts[j], blengths[j])), 1., out)
    end
end
```

A quick profile (that you might want to adjust if you're using an old
netbook...):
```.jl
X = randn(10_000, 2_000)
tX = X'
cl = [1 + div(i, 20) for i in 0:9_999]
bstarts = 1:20:10_000
blengths = fill(20, 500)

# Precompile so that we're not measuring compilation time. You can
# also just run things twice, but block_crossprod! takes about a minute...
precompile(block_crossprod!, (Array{Float64}, Array{Float64}, Array{Int}))
precompile(block_crossprod2!, (Array{Float64}, Array{Float64}, Array{Int}))
precompile(block_crossprod3!, (Array{Float64}, Array{Float64}, UnitRange{Int}, Array{Int}))
precompile(colwise_crossprod2!, (Array{Float64}, Array{Float64}, Array{Int}))
precompile(colwise_crossprod3!, (Array{Float64}, Array{Float64}, UnitRange{Int}, Array{Int}))

res = zeros(2_000,2_000)
@time block_crossprod!(res, X, cl)
# elapsed time: 59.312491 seconds (48326294568 bytes allocated, 29.67% gc time)

res = zeros(2_000,2_000)
@time block_crossprod2!(res, X, cl)
# elapsed time: 1.775726 seconds (163074568 bytes allocated, 7.73% gc time)

res = zeros(2_000,2_000)
@time block_crossprod3!(res, X, bstarts, blengths)
# elapsed time: 1.241094 seconds (354416 bytes allocated)

res = zeros(2_000,2_000)
@time colwise_crossprod2!(res, tX, cl)
# elapsed time: 1.505343 seconds (163074568 bytes allocated, 6.82% gc time)

res = zeros(2_000,2_000)
@time colwise_crossprod3!(res, tX, bstarts, blengths)
# elapsed time: 1.181818 seconds (348032 bytes allocated)
```

Concluding thoughts:

* The memory allocation for the subarray version is kind of astonishing.

* I don't know how to write equivalent R code, but I'm sure it could
be done, and this might be an interesting benchmark.

* Experimenting with the BLAS calling conventions is a hell of a lot
easier and more productive in an interpreted language than when I've
had to do this in a compiled environment. Once I figured out that I
wanted `syrk` (i.e, read through the list of BLAS functions until I
found what I wanted) and figured out how to access it (prepend
`Base.BLAS.`), it took about 2 minutes to get `block_crossprod2` to
work. (my first attempts passed the 1s as integers and passed `out` as
a symmetric array.)


[0]: https://groups.google.com/forum/#!topic/julia-users/oVsUqh83ps8
[1]: http://julia.readthedocs.org/en/latest/stdlib/linalg/#Base.LinAlg.BLAS.syrk
[2]: http://julia.readthedocs.org/en/latest/manual/performance-tips/#access-arrays-in-memory-order-along-columns