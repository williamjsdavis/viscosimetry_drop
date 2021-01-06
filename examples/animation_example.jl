using ViscosityDrop

### Setup simulation
filename = "example"
dir = "."
Ny, Nz = 32, 32
do_all(filename, dir, Ny=Ny, Nz=Nz, yLength=2, zLength=2,
                      ν=1e-1,
                      z_position=0.6, width=0.2, amplitude=-1e-1,
                      Δt=0.002, stop_time=40.0, iteration_interval=1000,
                      schedule_interval=0.5, output_fields = :all)

### Open simulation
using JLD2
file = jldopen("./example.jld2")

Ly = file["grid/Ly"]
Lz = file["grid/Lz"]
yb = range(-Ly/2,Ly/2,length=Ny)
zb = range(-Lz,0,length=Nz)

iterations = parse.(Int, keys(file["timeseries/t"]))

### Make animations
using Printf
using Plots
anim1 = @animate for iter in iterations
    t = file["timeseries/t/$iter"]*7.4e-2
    b_snapshot = file["timeseries/b/$iter"][1, :, :]

    contourf(yb, zb, b_snapshot',color=:balance,
             title="Vertical velocity, t=$(@sprintf("%.2f", t)) ms",
             aspect_ratio=:equal)
end
gif(anim1, "vorticity.gif", fps = 15)

anim2 = @animate for iter in iterations
    t = file["timeseries/t/$iter"]*7.4e-2
    ω_snapshot = file["timeseries/ω/$iter"][1, 1:Ny, 1:Nz]

    contourf(yb, zb, ω_snapshot',color=:balance,
             title="Vorticity, t=$(@sprintf("%.2f", t)) ms",
             aspect_ratio=:equal)
end
gif(anim2, "vorticity.gif", fps = 15)
