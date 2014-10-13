# example call:
# @eachperiod y[t] = c + b[1]*y[t-1] + b[2]*y[t-2] + e[t] # call 1
# @eachperiod z[:] = c + b[1]*y[t-1] + b[2]*y[t-2] + e[t] # call 2
# @eachperiod begin                                       # call 3
#     y[t] = c + b[1]*y[t-1] + b[2]*y[t-2] + e1[t]
#     z[:] = 3y[t] - cz + a[1]*y[t-1] + a[2]*y[t-2] + e2[t]
# end

# Call 2 should create z with just enough elements to contain the
# generated elements. For now, hard code the `t` but I can imagine
# wanting the macro to infer the index if there's only one. We'll put
# Call 3 on the wishlist for now

# expected code for call 1
# ------------------------
# n = length(y)
# @assert n >= 3 && length(e) == n
# for t in 3:n
#     y[t] = c + b[1]*y[t-1] + b[2]*y[t-2] + e[t]
# end
using Base.Meta
import Base.filter

getsymbolargs(s::Symbol) = s
getsymbolargs(n::Number) = Symbol[]
function getsymbolargs(e::Expr)
    @assert isexpr(e, :call)
    [[getsymbolargs(a) for a in e.args[2:end]]...]
end

offsets(s::Symbol) = Expr[]
function offsets(e::Expr)
    isexpr(e, :ref) &&  return e.args[2:end]
    isexpr(e, :call) && return [[offsets(a) for a in e.args[2:end]]...]
    isexpr(e, :(=)) && return [offsets(e.args[1]), offsets(e.args[2])]
end

filter(f::Function, s::Symbol) = f(s) ? s : Symbol[]
filter(f::Function, e::Expr) = filter(f, e, 1)
filter(f::Function, e::Expr, pos::Integer) =
    f(e) ? e : [[filter(f, a) for a in e.args[pos:end]]...]

exprleaves(s::Symbol, pos::Integer) = s
exprleaves(e::Expr, pos::Integer) =
    [[typeof(a) == Expr? exprleaves(a, pos) : a for a in e.args[pos:end]]...]
    

function hasduplicates(a)
    length(a) == 1 && return false
    a1 = a[1]
    for i in 2:length(a)
        a[i] == a1 || return true
    end
    false
end

function compchain(s::Symbol, A::Array)
    r = Array(Any, 2 * length(A) - 1)
    r[1:2:end] = A
    r[2:2:end] = s
    Expr(:comparison, r...)
end

macro eachperiod(e1)
    # For now, this macro only works for assignments to elements of a
    # vector.
    @assert(isexpr(e1, :(=)) && isexpr(e1.args[1], :ref) &&
            length(e1.args[1].args) == 2)
    
    vecrefs = filter(x -> !(typeof(x.args[2]) <: Number),
                     [[filter(x -> isexpr(x, :ref), a) for a in e1.args]...])
    vecs = unique(map(x -> x.args[1], vecrefs))
    indexvals = unique(map(x -> x.args[2], vecrefs))

    indexsym = filter(x -> typeof(x) == Symbol,
                       [[exprleaves(i, 2) for i in indexvals]...])
    @assert !hasduplicates(indexsym)
    indexsym = indexsymb[1]
    ## @assert !hasduplicates(indexvar)
    ## indexvar = indexvar[1]
    quote
        n = length($(vecs[1]))
        @assert $(compchain(:(==), [n, map(x -> :(length($x)), vecs[2:end])...]))
        for 
    end
end

# expected code for call 2
# ------------------------
# n = length(y)
# @assert n >= 3 && length(e) == n
# if !isdefined(z)
#     z1 = c + b[1]*y[2] + b[2]*y[1] + e[3]
#     z = Array(typeof(z1), n - 2)
#     z[1] = z1
# else
#     @assert length(z) == n - 2
# end
# for t in 4:n
#     z[t-2] = c + b[1]*y[t-1] + b[2]*y[t-2] + e[t]
# end
