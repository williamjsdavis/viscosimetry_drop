function makeModel(grid2D, ν; timestepper = :RungeKutta3, advection = WENO5())

    v_bcs, w_bcs = no_slip_bc(grid2D)

    return IncompressibleModel(timestepper = timestepper,
                                advection =  advection,
                                        grid = grid2D.grid,
                                  buoyancy = BuoyancyTracer(),
                                tracers = :b,
                        boundary_conditions = (v=v_bcs, w=w_bcs),
                                    closure = IsotropicDiffusivity(ν = 1e-2, κ = 0))
end

#=
model2D = IncompressibleModel(timestepper = :RungeKutta3,
                      advection = WENO5(),
                           grid = grid2D,
                       buoyancy = BuoyancyTracer(),
                        tracers = :b,
            boundary_conditions = (v=v_bcs, w=w_bcs),
                        closure = IsotropicDiffusivity(ν = 1e-2,
                                                       κ = 0)
)
=#
