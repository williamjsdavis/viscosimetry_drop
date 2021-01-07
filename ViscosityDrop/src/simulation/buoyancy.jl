function set_buoyancy!(model; z_position=0.6, width=0.3, amplitude=-1e-1)
    y_position = 0.0
    circ(x,y,z) = width>sqrt((y-y_position)^2 + (z+z_position)^2)
    initial_buoyancy(x,y,z) = amplitude*circ(x,y,z)
    set!(model, b=initial_buoyancy)
    return nothing
end
