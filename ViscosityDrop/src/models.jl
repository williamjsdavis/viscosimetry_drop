function make_model(grid, ν; timestepper = :RungeKutta3, advection = WENO5())

    v_bcs, w_bcs = no_slip_bc(grid)

    return IncompressibleModel(timestepper = timestepper,
                                 advection =  advection,
                                      grid = grid,
                                  buoyancy = BuoyancyTracer(),
                                   tracers = :b,
                       boundary_conditions = (v=v_bcs, w=w_bcs),
                                   closure = IsotropicDiffusivity(ν = 1e-2, κ = 0))
end
