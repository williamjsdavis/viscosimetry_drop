module ViscosityDrop

using Oceananigans
using Optim
using JLD2

greet() = print("Hello World!")
export greet

using Oceananigans.Grids
include("grid.jl")
export make_grid

include("boundary_conditions.jl")
export no_slip_bc

using Oceananigans.Advection
include("model.jl")
export make_model

include("buoyancy.jl")
export set_buoyancy!

using Oceananigans.AbstractOperations
using Oceananigans.Fields
using Oceananigans.OutputWriters
include("simulation.jl")
export make_simulation

end # module
