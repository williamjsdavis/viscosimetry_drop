module ViscosityDrop

using Oceananigans
using Optim
using JLD2

greet() = print("Hello World!")
export greet

using Oceananigans.Grids
include("grid.jl")
export Bounded2DGrid

end # module
