using ViscosityDrop
using Test

@testset "Grid equal" begin
    grid32 = Bounded2DGrid(32,32,2,2)
    @test grid32.Ny == 32
    @test grid32.Nz == 32
    @test grid32.yLength == 2.0
    @test grid32.zLength == 2.0
    @test isa(grid32.Ny, Int)
    @test isa(grid32.Nz, Int)
    @test isa(grid32.yLength, Float64)
    @test isa(grid32.zLength, Float64)
    @test isa(grid32.grid, RegularCartesianGrid)
    @test grid32.grid.Nx == 1
    @test grid32.grid.Ny == 32
    @test grid32.grid.Nz == 32
    @test grid32.grid.Ly == 2.0
    @test grid32.grid.Lz == 2.0
end

@testset "Grid unequal" begin
    grid32 = Bounded2DGrid(16,32,2,3)
    @test grid32.Ny == 16
    @test grid32.Nz == 32
    @test grid32.yLength == 2.0
    @test grid32.zLength == 3.0
    @test isa(grid32.Ny, Int)
    @test isa(grid32.Nz, Int)
    @test isa(grid32.yLength, Float64)
    @test isa(grid32.zLength, Float64)
    @test isa(grid32.grid, RegularCartesianGrid)
    @test grid32.grid.Nx == 1
    @test grid32.grid.Ny == 16
    @test grid32.grid.Nz == 32
    @test grid32.grid.Ly == 2.0
    @test grid32.grid.Lz == 3.0
end
