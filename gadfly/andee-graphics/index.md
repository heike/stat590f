<style>
.reveal code.r {
  font-size: larger
}
</style>

Graphics in Julia
========================================================
author: Andee Kaplan
date: 09-10-2014

Packages
========================================================

There are multiple packages written for Julia that facilitate graphics. The main difference between their use is the api syntax.

- [Winston](http://winston.readthedocs.org/en/latest/) (Matlab)
- [Gaston](https://github.com/mbaz/Gaston.jl) (gnuplot)
- [ASCIIPlots](https://github.com/johnmyleswhite/ASCIIPlots.jl) (Exactly what you think it is. I'm not joking.)
- [PyPlot](https://github.com/stevengj/PyPlot.jl) (Python matplotlib)
- [Gadfly](http://dcjones.github.io/Gadfly.jl/) (grammar of graphics)

Winston
========================================================
- ~~Static~~ 2D plotting library for Julia
- Syntax similar to Matlab


```r
using Winston

x = rand(10);
y = rand(10);
plot(x, y, "bo");

savefig("winston_plot.pdf");
```

Winston Example Plot
========================================================
In order to print the plot, must save the plot, and insert into a `div` below.

<div align = "center">
  <object data="plots-julia/winston_plot.svg" type="image/svg+xml" width="600" height="400"></object>
</div>

Winston Capabilities/Issues
=======================================================
- Basic plotting functionality 
  - scatter plots, line plots, bar charts(ish)
  - plotting functions
  - titles/labels
  - saving (pdf, svg, png, eps)
- Very sparse documentation
- Syntax not very intuitive (to me)
- Limited options/flexibility


Gaston
========================================================
- Wrapper for utilizing `gnuplot` from Julia
- ~~Static~~ 2D plots, 3D surfaces, and image plots


```r
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
```

Gaston Code (cont'd)
==========================================================================

```r
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
```

Gaston Example Plots
=============================================================
<img src="plots-julia/gaston_2d.png" style="height: 33%"></img>
<img src="plots-julia/gaston_histo.png" style="height: 33%"></img>
<img src="plots-julia/gaston_3d.png" style="height: 32%"></img>

Gaston Capabilities/Issues
=======================================================
- Basic plotting functionality 
  - scatter plots, line plots, histograms, etc.
  - can overlay histograms/line charts with "mid-level" plotting
  - titles/labels
  - saving (pdf, svg, png, gif)
- Decent documentation (plus documentation for `gnuplot` is extensive)
- Limited options/flexibility
- Installation issues (more of a `gnuplot` issue than `Gaston`)


ASCIIPlots
=======================================================
- So bad it's good?

![Jump the shark](fonziejumpsshark3sl.gif)

PyPlot
========================================================
- Wrapper for utilizing `matplotlib` (Python) from Julia


Gadfly
========================================================
- Implementation of the grammar of graphics in Julia

