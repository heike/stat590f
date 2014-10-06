IJulia
========================================================
author: Eric Hare & Andee Kaplan
date: October 8, 2014

<img src="images/ijulialogo.png" height=100/>

What is IPython?
========================================================
Rich architecture for interactive computing with:
- Powerful Python shells (terminal and Qt-based).
- A web-based notebook with the same core features but support for code, text, mathematical expressions, inline plots and other rich media.
- Support for interactive data visualization and use of GUI toolkits.
- Flexible, embeddable interpreters to load into your own projects.
- Easy to use, high performance tools for parallel computing.

[[Source]](http://ipython.org/)

IPython \(\rightarrow\) Project Jupyter
========================================================
<img src="images/jupyter-logo.png" height=70 />

Created in Summer 2014 by the IPython development team to carry forward a vision of reproducible interactive computing for all programming languages:
- Python
- Julia
- R
- Ruby, Haskell, Scala, Go, etc.

Jupyter goals
=========================================================
A home for the language independent parts of the architecture:
- A network protocol for applications to talk to kernels that run code for interactive computations.
- A set of applications that enable users to write and run code on those kernels.
- Notebook file format and conversion tools (nbconvert).
- Notebook sharing service (https://nbviewer.jupyter.org/).

[[Source]](http://nbviewer.ipython.org/github/ellisonbg/talk-2014-summer/blob/master/Jupyter%20and%20IPython.ipynb)

IJulia
========================================================
IJulia is a Julia-language backend (kernel) for use with IPython/Jupyter notebooks.

You can run an IJulia notebook a few different ways:
- In Julia, at the `julia>` prompt, you can type

```{}
using IJulia
notebook()
```
- Alternatively, you can run from the command line

```{eval=FALSE}
ipython notebook --profile julia
```

[[Source]](https://github.com/JuliaLang/IJulia.jl)

JupyterHub
=======================================================
A multi-user server to manage and proxy multiple instances of the single-user IPython Jupyter notebook server.

With `oauthenticator` plugin, able to use GitHub usernames as login!

~~Currently in development, so be kind.~~

[[Source]](https://github.com/jupyter/jupyterhub)

Try it out!
=======================================================

http://www.mlcape.com:8000

Installation
=======================================================
1. Install GitHub/development version (3.0) of `IPython` at https://github.com/ipython/ipython (Use sudo for system-wide installation)
2. Follow the installation steps for `jupyterhub` at https://github.com/jupyter/jupyterhub
3. (Optional) For GitHub authentication:
    - Install `Docker` (sudo apt-get install docker.io)
    - Install `oauthenticator` from https://github.com/jupyter/oauthenticator
4. Run server with `sudo jupyterhub`
5. Browse to `http://localhost:8000`

Adding Kernels = Hours of frustration
=======================================================
1. For R Kernel:
    - Install `IRKernel` from https://github.com/takluyver/IRkernel
2. For Julia Kernel:
    - Install `IJulia` by running `Pkg.add("IJulia")` from your julia session
    - Create a file /home/$USER/.ipython/kernels/julia/kernel.json where `$USER` is your system username
    - Add the text `{"display_name":"Julia","argv":
    ["/usr/bin/julia","-i","-F",
    "/home/$USER/.julia/v0.3/IJulia/src/kernel.jl",
    "{connection_file}"],"language":"julia",
    "codemirror_mode":"julia"}` 
    where `$USER` is once again your system username

Colaboratory - The near future?
=======================================================
