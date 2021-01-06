using ViscosityDrop
using Test

@testset "Grids equal points" begin
    grid = make_grid(32,32,2,2)
    @test grid.Nx == 1
    @test grid.Ny == 32
    @test grid.Nz == 32
    @test grid.Ly == 2.0
    @test grid.Lz == 2.0
end

@testset "Grids unequal points" begin
    grid = make_grid(16,32,2,3)
    @test grid.Nx == 1
    @test grid.Ny == 16
    @test grid.Nz == 32
    @test grid.Ly == 2.0
    @test grid.Lz == 3.0
end

@testset "Boundary conditions" begin
    grid32 = make_grid(16,32,2,3)
    v_bc, w_bc = no_slip_bc(grid32)

    @test v_bc.x.left.condition == nothing
    @test v_bc.x.right.condition == nothing
    @test v_bc.y.left.condition == 0.0
    @test v_bc.y.right.condition == 0.0
    @test v_bc.z.left.condition == 0.0
    @test v_bc.z.right.condition == 0.0

    @test w_bc.x.left.condition == nothing
    @test w_bc.x.right.condition == nothing
    @test w_bc.y.left.condition == 0.0
    @test w_bc.y.right.condition == 0.0
    @test w_bc.z.left.condition == 0.0
    @test w_bc.z.right.condition == 0.0
end

@testset "Making models (default)" begin
    grid = make_grid(16,32,2,3)
    v_bc, w_bc = no_slip_bc(grid)
    model = make_model(grid, 1e-2)

    @test model.closure.ν == 1e-2
    @test Core.Typeof(model.timestepper).name.name == :RungeKutta3TimeStepper
    @test Core.Typeof(model.advection).name.name == :WENO5
    @test model.clock.iteration == 0
end

@testset "Making models (other options)" begin
    using Oceananigans.Advection
    grid = make_grid(16,32,2,3)
    v_bc, w_bc = no_slip_bc(grid)
    model = make_model(grid, 1e-2; timestepper = :QuasiAdamsBashforth2,
                                     advection = CenteredSecondOrder())

    @test model.closure.ν == 1e-2
    @test Core.Typeof(model.timestepper).name.name == :QuasiAdamsBashforth2TimeStepper
    @test Core.Typeof(model.advection).name.name == :CenteredSecondOrder
    @test model.clock.iteration == 0
end

@testset "Adding buoyancy" begin
    grid = make_grid(32,32,2,2)
    v_bc, w_bc = no_slip_bc(grid)
    model = make_model(grid, 1e-2)

    @test all(model.tracers.b[1,1:32,1:32] .== 0.0)

    set_buoyancy!(model)
    @test !all(model.tracers.b[1,1:32,1:32] .== 0.0)
    @test model.tracers.b[1,15,25] == -1e-1
    @test model.tracers.b[1,5,25] == 0.0

    set_buoyancy!(model, z_position=0.6, width=0.3, amplitude=-2e-1)
    @test !all(model.tracers.b[1,1:32,1:32] .== 0.0)
    @test model.tracers.b[1,15,25] == -2e-1
    @test model.tracers.b[1,5,25] == 0.0
end

@testset "Simulation setup" begin
    filename = "tmp"
    dir = "."
    grid = make_grid(32,32,2,2)
    v_bc, w_bc = no_slip_bc(grid)
    model = make_model(grid, 1e-2)
    set_buoyancy!(model)

    sim = make_simulation(model, dir, filename, output_fields=:all)
    @test sim.iteration_interval == 1000
    @test sim.run_time == 0.0
    @test sim.stop_time == 40.0
    @test sim.Δt == 0.002
    @test sim.output_writers.vals[1].schedule.interval == 0.5
    @test typeof(sim.output_writers.vals[1]).parameters[1].parameters[1] == (:b, :v, :w, :ω, :s)
    @test isfile("./tmp.jld2")

    if isfile("./tmp.jld2")
        rm("./tmp.jld2")
    end

    sim2 = make_simulation(model, dir, filename, Δt=0.001,
                                                 stop_time=20.0,
                                                 iteration_interval=2000,
                                                 schedule_interval=0.4,
                                                 output_fields=:b)
    @test sim2.iteration_interval == 2000
    @test sim2.run_time == 0.0
    @test sim2.stop_time == 20.0
    @test sim2.Δt == 0.001
    @test sim2.output_writers.vals[1].schedule.interval == 0.4
    @test isfile("./tmp.jld2")

    if isfile("./tmp.jld2")
        rm("./tmp.jld2")
    end
end

@testset "Running simulation" begin
    filename = "tmp"
    dir = "."
    grid = make_grid(16,16,2,2)
    v_bc, w_bc = no_slip_bc(grid)
    model = make_model(grid, 1e-2)
    set_buoyancy!(model)

    sim = make_simulation(model, dir, filename, output_fields=:all, stop_time=2.0)
    run!(sim)

    @test sim.model.clock.time == 2.0
    @test isfile("./tmp.jld2")

    if isfile("./tmp.jld2")
        rm("./tmp.jld2")
    end
end

@testset "Wrapper" begin
    filename = "tmp"
    dir = "."

    do_all(filename, dir, stop_time=4)
    @test isfile("./tmp.jld2")

    using JLD2
    file = jldopen("./tmp.jld2")
    @test typeof(file["timeseries/t"]) == JLD2.Group{JLD2.JLDFile{JLD2.MmapIO}}
    @test file["timeseries/t/2004"] >= 4

    if isfile("./tmp.jld2")
        rm("./tmp.jld2")
    end
end
