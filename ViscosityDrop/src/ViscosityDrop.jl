module ViscosityDrop

using Oceananigans
using Optim
using JLD2
using DelimitedFiles

using Oceananigans.Grids
include("simulation/grid.jl")
export make_grid

include("simulation/boundary_conditions.jl")
export no_slip_bc

using Oceananigans.Advection
include("simulation/model.jl")
export make_model

include("simulation/buoyancy.jl")
export set_buoyancy!

using Oceananigans.AbstractOperations
using Oceananigans.Fields
using Oceananigans.OutputWriters
include("simulation/simulation.jl")
export make_simulation, run!

include("simulation/wrapper.jl")
export do_all

include("post_process/circle.jl")
include("post_process/fit_functions.jl")
include("post_process/get_results.jl")
export get_results

end # module
