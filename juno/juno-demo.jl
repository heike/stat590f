# Juno is a Light Table plugin
# to install, follow the directions here -- http://junolab.org/docs/installing.html

############
# Juno does:
############

# 1. tab completion (even for unicode: type \ and a list of options should appear)
# Y ∼ N(μ, σ²)

# 2. simple inline rendering of values
# to evaluate a line on Mac: Cmd + Enter
# to evaluate a line on PC: Ctrl + Enter
x = 1 + 1
typeof(x)
string("Value of x is $x")

# NOTE: expressions that don't return a value will just have √ when evaluated
println("Hmm")
# for this reason, you may want to: Ctrl+Space -- "Toggle Console"

# 3. Collapsable value rendering
[1:100]
["a", "b", "c"]
[1, "b", 2]
[1 2; 3 4]

# Moar types!
using DataFrames
dv = @data([NA, 3, 2, 5])
df = DataFrame(A = dv, B = ["M", "F", "F", "M"])
mean(df[:A])
mean(dropna(df[:A]))

# 4. Nifty lookups of various methods
# to show/hide methods on Mac: Cmd + m
# to show/hide methods on PC: Ctrl + m (i think)
DataFrame # put your cursor here, then press Cmd/Ctrl + m

# also documentation (ctrl + d)
DataFrame # put your cursor here, then press Ctrl + d

# notice "Main" to the bottom right of the editor
# that indicates we are currently working in the "Main module"
# the "current working module" can be modified (manually or automatically)
using Distributions
sample #sample(a::AbstractArray) lives in the StatsBase module


# 5. Embedded plots!
using Gadfly
plot(x = 1:10, y = 1:10)

# 6. You can also connect to your terminal or IJulia instance.
# Not sure how useful that is, but you can -- http://junolab.org/docs/terminal.html

#########################################################
# Of course, there are some things that could be improved
#########################################################

# 1. LT is an absolute hog of CPU and memory -- especially when
# left on for long periods of time. See here for more:
# https://github.com/LightTable/LightTable/issues/1088#issuecomment-56437833
# 2. Randomly becomes nonresponsive (maybe related to last issue?)
# 3. Value rendering sometimes messes with the cursor
