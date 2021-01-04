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
    model2D = make_model(grid, 1e-2)

    @test model2D.closure.ν == 1e-2
    @test Core.Typeof(model2D.timestepper).name.name == :RungeKutta3TimeStepper
    @test Core.Typeof(model2D.advection).name.name == :WENO5
    @test model2D.clock.iteration == 0
end

@testset "Making models (other options)" begin
    using Oceananigans.Advection
    grid = make_grid(16,32,2,3)
    v_bc, w_bc = no_slip_bc(grid)
    model2D = make_model(grid, 1e-2; timestepper = :QuasiAdamsBashforth2,
                                     advection = CenteredSecondOrder())

    @test model2D.closure.ν == 1e-2
    @test Core.Typeof(model2D.timestepper).name.name == :QuasiAdamsBashforth2TimeStepper
    @test Core.Typeof(model2D.advection).name.name == :CenteredSecondOrder
    @test model2D.clock.iteration == 0
end

@testset "Adding buoyancy" begin
    grid = make_grid(32,32,2,2)
    v_bc, w_bc = no_slip_bc(grid)
    model2D = make_model(grid, 1e-2)

    @test all(model2D.tracers.b[1,1:32,1:32] .== 0.0)

    set_buoyancy!(model2D)
    @test !all(model2D.tracers.b[1,1:32,1:32] .== 0.0)
    @test model2D.tracers.b[1,15,25] == -1e-1
    @test model2D.tracers.b[1,5,25] == 0.0

    set_buoyancy!(model2D, z_position=0.6, width=0.3, amplitude=-2e-1)
    @test !all(model2D.tracers.b[1,1:32,1:32] .== 0.0)
    @test model2D.tracers.b[1,15,25] == -2e-1
    @test model2D.tracers.b[1,5,25] == 0.0
end
