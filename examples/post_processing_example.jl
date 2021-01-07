using ViscosityDrop

### Setup simulation and run
filename = "example"
dir = "."
Ny, Nz = 64, 64
do_all(filename, dir, Ny=Ny, Nz=Nz, yLength=2, zLength=2,
                      ν=1e-1,
                      z_position=0.6, width=0.2, amplitude=-1e-1,
                      Δt=0.002, stop_time=120.0, iteration_interval=1000,
                      schedule_interval=0.5, output_fields = :all)
### Post-process (also saves to txt file)
out_results = get_results(dir, dir, "example.jld2"; Ncourse=11, verbose=false)

### Plot results
using Plots

p1 = plot(out_results[:,1],out_results[:,2],
          label="test1", title="Circle radius");
p2 = plot(out_results[:,1],out_results[:,3],
          label="test1", title="y-position");
p3 = plot(out_results[:,1],out_results[:,4],
          label="test1", title="z-position");
p4 = plot(out_results[:,1],out_results[:,5],
          label="test1", title="Circle misfit");
p_all = plot(p1, p2, p3, p4, layout = (2, 2), legend = false)
savefig(p_all, "results.pdf")
