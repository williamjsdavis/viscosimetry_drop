function make_simulation(model, dir, filename; Δt=0.002,
                                               stop_time=40.0,
                                               iteration_interval=1000,
                                               schedule_interval=0.5,
                                               output_fields = :b)

    progress(sim) = @info "Iteration: $(sim.model.clock.iteration), time: $(round(Int, sim.model.clock.time))"

    simulation = Simulation(model, Δt=Δt,
                                   stop_time=stop_time,
                                   iteration_interval=iteration_interval,
                                   progress=progress)

    scheduler = TimeInterval(schedule_interval)

    #NOTE: Nan-checker currently not working
    #simulation.diagnostics[:nc] = nc

    output_writer!(simulation, output_fields, model, scheduler, dir, filename)

    return simulation
end
function get_fields(model)
    u, v, w = model.velocities
    b = model.tracers.b

    s = sqrt(v^2 + w^2)
    ω = ∂y(w) - ∂z(v)

    s_field = ComputedField(s)
    ω_field = ComputedField(ω)

    return u, v, w, b, s_field, ω_field
end
function output_writer!(simulation, output_fields, model, scheduler, dir, filename)
    u, v, w, b, s_field, ω_field = get_fields(model)
    if output_fields == :b
        simulation.output_writers[:fields] =
            JLD2OutputWriter(model, b,
                             dir = dir,
                             schedule = scheduler,
                             prefix = filename,
                             force = true)
    elseif output_fields == :all
        simulation.output_writers[:fields] =
            JLD2OutputWriter(model, (b=b, v=v, w=w, ω=ω_field, s=s_field),
                             dir = dir,
                             schedule = scheduler,
                             prefix = filename,
                             force = true)
    else
        throw(ArgumentError("Unknown output field(s)"))
    end
    return nothing
end
