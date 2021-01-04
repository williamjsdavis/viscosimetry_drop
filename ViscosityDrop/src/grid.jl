function make_grid(Ny, Nz, yLength, zLength)
    return RegularCartesianGrid(topology = (Bounded, Bounded, Bounded),
                                size=(1, Ny, Nz),
                                x=(-π, π),
                                y=(-yLength/2, yLength/2),
                                z=(-zLength, 0))
end
