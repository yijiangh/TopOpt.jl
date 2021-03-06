# TopOpt

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- [![Build Status](https://travis-ci.org/YingboMa/SafeTestsets.jl.svg?branch=master)](https://travis-ci.org/mohamed82008/TopOpt.jl) -->
[![Actions Status](https://github.com/mohamed82008/TopOpt.jl/workflows/CI/badge.svg)](https://github.com/mohamed82008/TopOpt.jl/actions)
[![codecov](https://codecov.io/gh/mohamed82008/TopOpt.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/mohamed82008/TopOpt.jl)
[![Documentation](https://img.shields.io/badge/doc-latest-blue.svg)](https://mohamed82008.github.io/TopOpt.jl/dev)

`TopOpt` is a topology optimization package written in [Julia](https://github.com/JuliaLang/julia).

## Installation

To install `TopOpt.jl`, you can either (1) add it to an existing Julia environment or (2) [clone and use its shipped environment](https://pkgdocs.julialang.org/v1/environments/#Using-someone-else's-project).
The second option is recommended for new users who simply wants to try this package out.

### Adding `TopOpt` to an existing Julia environment

In Julia v1.0+ you can install packages using Julia's package manager as follows:

```julia
using Pkg
pkg"add https://github.com/mohamed82008/TopOpt.jl#master"
```

which will track the `master` branch of the package. To additionally load the visualization submodule of `TopOpt`, you will need to install `Makie.jl` using:

```julia
pkg"add Makie"
```

To load the package, use:

```julia
using TopOpt
```

and to optionally load the visualization sub-module as part of `TopOpt`, use:

```julia
using TopOpt, Makie
```
