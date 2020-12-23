struct Bounded2DGrid
    Ny::Integer
    Nz::Integer
    yLength::Float64
    zLength::Float64
    grid::RegularCartesianGrid
    function Bounded2DGrid(Ny, Nz, yLength, zLength)
        grid = RegularCartesianGrid(topology = (Bounded, Bounded, Bounded),
                                    size=(1, Ny, Nz),
                                    x=(-π, π),
                                    y=(-yLength/2, yLength/2),
                                    z=(-zLength, 0)
        )
        return new(Ny, Nz, yLength, zLength, grid)
    end
end

#=
function make_2D_grid(Ny=64, Nz=64, yLength=2.0, zLength=2.0)
    grid = RegularCartesianGrid(topology = (Bounded, Bounded, Bounded),
                                size=(1, 64, 64),
                                x=(-π, π),
                                y=(-yLength/2, yLength/2),
                                z=(-zLength, 0)
    )
    return grid
end
=#
