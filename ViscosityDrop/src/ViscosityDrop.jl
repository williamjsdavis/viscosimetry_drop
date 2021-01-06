module ViscosityDrop

using Oceananigans
using Optim
using JLD2
using DelimitedFiles

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
export make_simulation, run!

include("wrapper.jl")
export do_all

include("post_process/circle.jl")
include("post_process/fit_functions.jl")
include("post_process/get_results.jl")
export get_results

end # module
