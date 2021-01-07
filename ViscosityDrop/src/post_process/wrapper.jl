function do_all(filename, dir; Ny=32, Nz=32, yLength=2, zLength=2,
                               ν=1e-2, timestepper = :RungeKutta3, advection = WENO5(),
                               z_position=0.6, width=0.3, amplitude=-1e-1,
                               Δt=0.002, stop_time=40.0, iteration_interval=1000,
                               schedule_interval=0.5, output_fields = :all)

    grid = make_grid(Ny, Nz, yLength, zLength)
    v_bc, w_bc = no_slip_bc(grid)
    model = make_model(grid, ν)
    set_buoyancy!(model, z_position=z_position,
                         width=width,
                         amplitude=amplitude)
    sim = make_simulation(model, dir, filename, Δt=Δt,
                                                stop_time=stop_time,
                                                iteration_interval=iteration_interval,
                                                schedule_interval=schedule_interval,
                                                output_fields=output_fields)
    run!(sim)
    return nothing
end
