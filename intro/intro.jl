# This first look at Julia is a mashup of 
# Leah Hanson's "Learn X in Y minutes where X=Julia"
# and the Julia documentation on DataFrames 

# Single line comments start with a number symbol.
#= Multiline comments can be written
   by putting '#=' before the text  and '=#' 
   after the text. They can also be nested.
=#

####################################################
## 1. Primitive Datatypes and Operators
####################################################

# Everything in Julia is a expression.

# There are several basic types of numbers.
3 # => 3 (Int64)
typeof(3)
3.2 # => 3.2 (Float64)
typeof(3.2)
# division of integers results in Float64
typeof(3/2)

# interesting additional data types
2//3
typeof(2//3)
2 + 1im # => 2 + 1im (Complex{Int64})

x = 1+1im
conj(x)*x

# All of the normal infix operators are available.
# i.e. everything your calculator can do ...
1 + 1 # => 2
8 - 1 # => 7
10 * 2 # => 20
35 / 5 # => 7.0
2 ^ 2 # => 4 # power, not bitwise xor
12 % 10 # => 2
div(5, 2) # => 2 # for a truncated result, use div
# matlab absurdity, but ok (might sometimes have use for matrix operators): 
5 \ 35 # => 7.0 

# Boolean values are primitives
true
false

# Boolean operators
!true # => false
!false # => true
1 == 1 # => true
2 == 1 # => false
1 != 1 # => false
2 != 1 # => true
1 < 10 # => true
1 > 10 # => false
2 <= 2 # => true
2 >= 2 # => true
# Comparisons can be chained
1 < 2 < 3 # => true
2 < 3 < 2 # => false

# Strings are created with "
"This is a string."

# Character literals are written with '
'a'

# A string can be indexed like an array of characters
"This is a string"[1] # => 'T' # Julia indexes from 1
# However, this is will not work well for UTF8 strings,

# $ can be used for string interpolation:
"2 + 2 = $(2 + 2)" # => "2 + 2 = 4"
# You can put any Julia expression inside the parenthesis.

# Another way to format strings is the printf macro.
@printf "%d is less than %f" 4.5 5.3 # 5 is less than 5.300000

# Printing is easy
println("I'm Julia. Nice to meet you!")

####################################################
## 2. Variables and Collections
####################################################

# You don't declare variables before assigning to them.
some_var = 5 # => 5
some_var # => 5

# Accessing a previously unassigned variable is an error
some_other_var # => ERROR: some_other_var not defined

# Variable names start with a letter.
# After that, you can use letters, digits, underscores, and exclamation points.
SomeOtherVar123! = 6 # => 6

# You can also use unicode characters
☃ = 8 # => 8
# These are especially handy for mathematical notation
2 * π # => 6.283185307179586
π/π-1

# A note on naming conventions in Julia:
#
# * Names of variables are in lower case, with word separation indicated by
#   underscores ('\_').
#
# * Names of Types begin with a capital letter and word separation is shown
#   with CamelCase instead of underscores.
#
# * Names of functions and macros are in lower case, without underscores.
#
# * Functions that modify their inputs have names that end in !. These
#   functions are sometimes called mutating functions or in-place functions.

# Arrays store a sequence of values indexed by integers 1 through n:
a = Int64[] # empty array

# 1-dimensional array literals can be written with comma-separated values.
b = [4, 5, 6] # => 3-element Int64 Array: [4, 5, 6]
b[1] # => 4
b[end] # => 6

# 2-dimentional arrays use space-separated values and semicolon-separated rows.
matrix = [1 2; 3 4] # => 2x2 Int64 Array: [1 2; 3 4]

# Function names that end in exclamations points indicate that they modify
# their argument.

# Add stuff to the end of a list with push! and append!
push!(a,1)     # => [1]
push!(a,2)     # => [1,2]
push!(a,4)     # => [1,2,4]
push!(a,3)     # => [1,2,4,3]

# some things are different from R: no component wise operations
a/b
a*b
a/b * b

# first element will be changed 
append!(a,b) # => [1,2,4,3,4,5,6]
a
b

# Remove from the end with pop
pop!(b)        # => 6 and b is now [4,5]

# Let's put it back
push!(b,6)   # b is now [4,5,6] again.


arr = [5,4,6] # => 3-element Int64 Array: [5,4,6]
sort(arr) # => [4,5,6]; arr is still [5,4,6]
sort!(arr) # => [4,5,6]; arr is now [4,5,6]

# Looking out of bounds is a BoundsError
    a[0] # => ERROR: BoundsError() in getindex at array.jl:270
    a[end+1] # => ERROR: BoundsError() in getindex at array.jl:270


# Errors list the line and file they came from, even if it's in the standard
# library. If you built Julia from source, you can look in the folder base
# inside the julia folder to find these files.

# You can initialize arrays from ranges
a = [1:5] # => 5-element Int64 Array: [1,2,3,4,5]

# this is different from 
x = 1:5
typeof(1:5)
typeof([1:5])

# some things are the same as in R
# You can look at ranges with slice syntax.
a[1:3] # => [1, 2, 3]
a[2:end] # => [2, 3, 4, 5]

# ... but not everything: negative indices are out of bounds:
a[-1]

# instead: Remove elements from an array by index with splice!
splice!(a,1) # => 1 ; a is now [2:5]



# Concatenate lists with append!
b = [1,2,3]
append!(a,b) # Now a is [1, 2, 3, 4, 5, 1, 2, 3]

# Check for existence in a list with in
in(1, a) # => true

# Examine the length with length
length(a) # => 8

# new concept: tuples
# Tuples are immutable, i.e. cannot be changed.
tup = (1, 2, 3) # => (1,2,3) # an (Int64,Int64,Int64) tuple.
tup[1] # => 1
try:
    tup[1] = 3 # => ERROR: no method setindex!((Int64,Int64,Int64),Int64,Int64)
catch e
    println(e)
end

# Many list functions also work on tuples
length(tup) # => 3
tup[1:2] # => (1,2)
in(2, tup) # => true

# You can unpack tuples into variables
a, b, c = (1, 2, 3) # => (1,2,3)  # a is now 1, b is now 2 and c is now 3

# Tuples are created even if you leave out the parentheses
d, e, f = 4, 5, 6 # => (4,5,6)

# A 1-element tuple is distinct from the value it contains
(1,) == 1 # => false
(1) == 1 # => true

# This is neat!
# Look how easy it is to swap two values
e, d = d, e  # => (5,4) # d is now 5 and e is now 4

# there are also Sets ....

Set(1,2,3,4,4,4,4)
##################################
# let's use some datasets!

# Julia has a package system
# Pkg.add("package name") installs package "package name"
#
# Pkg.add("DataFrames")
using DataFrames
using RDatasets

iris = dataset("datasets", "iris")
head(iris)

typeof(iris)
summary(iris)
names(iris)
iris[1] # call by position
iris[:SepalLength] # call by name

iris[[:SepalLength, :SepalWidth]]

# not dim, but size
dim(iris)
size(iris)


colwise(median, iris[1:4]) 

by(iris, :Species, size)
by(iris, :Species, df -> mean(df[:PetalLength]))
by(iris, :Species, df -> DataFrame(N = size(df, 1)))
by(iris, :Species, df -> DataFrame(N = size(df, 1), pl=mean(df[:PetalLength])))

# some things are similar to R
help(by)
quit() 