##Winston Plot Example
using Winston

x = rand(10);
y = rand(10);
plot(x, y, "bo");

savefig("winston_plot.pdf");

#########################
##Gaston Plot Examples
using Gaston

#2D plot
t = 0:0.0001:.15
carrier = cos(2pi*t*200)
modulator = 0.7+0.5*cos(2pi*t*15)
am = carrier.*modulator
plot(t,am,"color","blue","legend","AM DSB-SC","linewidth",1.5,
t,modulator,"color","black","legend","Envelope",
t,-modulator,"color","black","title","AM DSB-SC example",
"xlabel","Time (s)","ylabel","Amplitude",
"box","horizontal top left")
set_filename("plots-julia/gaston_2d.png")
printfigure("png")

#Histogram
y = sqrt( randn(1000).^2 + randn(1000).^2 )
histogram(y,"bins",25,"norm",1,"color","blue","title","Rayleigh density (25 bins)")
set_filename("plots-julia/gaston_histo.png")
printfigure("png")

#3D Surface
gnuplot_send("set view 67,25")
surf(-3:.1:3,-3:0.1:3,(x,y)->cos(x)*sin(y),"plotstyle","points",
"xlabel","coord 1","ylabel","coord 2","zlabel","coord 3",
"title","surf demo","color","blue")
set_filename("plots-julia/gaston_3d.png")
printfigure("png")

################################################
##ASCIIPlots, not a joke.
using ASCIIPlots
x = 2 * pi * rand(30)
y = sin(x) + 0.1 * randn(30)
scatterplot(x, y, sym = '*')

#################################################
##PyPlot
using PyPlot
x = 0:.5:5
y = exp(-x)

errorbar(x, y, xerr=0.2, yerr=0.4)
savefig("plots-julia/PyPlot_errorbar.svg")

N = 50
x = rand(N)
y = rand(N)
colors = rand(N)
area = pi * (15 * rand(N))

scatter(x, y, s=area, c=colors, alpha=0.5)
savefig("plots-julia/PyPlot_scatter.svg")

##Animations
using PyCall
using PyPlot
@pyimport matplotlib.animation as anim

# First set up the figure, the axis, and the plot element we want to animate
fig = figure()
ax = plt.axes(xlim=(0, 2), ylim=(-2, 2))
global line = ax[:plot]([], [], lw=2)[1]

# initialization function: plot the background of each frame
function init()
    global line
    line[:set_data]([], [])
    return (line,None)
end
# animation function.  This is called sequentially
function animate(i)
    x = linspace(0, 2, 1000)
    y = sin(2 * pi * (x - 0.01 * i))
    global line
    line[:set_data](x, y)
    return (line,None)
end

# call the animator.  blit=True means only re-draw the parts that have changed.
myanim = anim.FuncAnimation(fig, animate, init_func=init,
                               frames=100, interval=20)

myanim[:save]("plots-julia/PyPlots-sinplot.mp4", extra_args=["-vcodec", "libx264", "-pix_fmt", "yuv420p"])

