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
