function get_results(data_dir, results_dir, filename; Ncourse=21,
                                                      threshold_level=-0.05,
                                                      verbose=true)

    location = data_dir * "/" * filename
    file = jldopen(location)

    t_vec, r_vec, y_vec, z_vec, e_vec = get_data(file,
                                                 Ncourse,
                                                 threshold_level,
                                                 verbose)

    save_results(results_dir, filename, t_vec, r_vec, y_vec, z_vec, e_vec)
    return [t_vec r_vec y_vec z_vec e_vec]
end
function get_info(file)
    Ly = file["grid/Ly"]
    Lz = file["grid/Lz"]
    Ny = file["grid/Ny"]
    Nz = file["grid/Nz"]
    return Ly, Lz, Ny, Nz
end
function get_data(file, Ncourse, threshold_level, verbose)

    iterations = parse.(Int, keys(file["timeseries/t"]))

    Nt = length(iterations)
    t_vec = zeros(Nt)
    r_vec = zeros(Nt)
    y_vec = zeros(Nt)
    z_vec = zeros(Nt)
    ∂z∂t_vec = zeros(Nt-1)
    e_vec = zeros(Nt)

    Ly, Lz, Ny, Nz = get_info(file)
    ynodes = range(-Ly/2,Ly/2,length=Ny)
    znodes = range(-Lz,0,length=Nz)
    guess_cache = circ_guess.(ynodes, znodes',0,0,0)
    gridCoarse = ParameterGrid2D(Ly,Lz,Ncourse)

    threshold(x) = x < threshold_level

    for (i, iter) in enumerate(iterations)
        # retrieve solution from JLD2 file
        if verbose println("Step: ", i, "/", Nt) end
        b_bitmap = threshold.(file["timeseries/b/$iter"][1, :, :])
        res = coarse_fine_search(gridCoarse, b_bitmap, guess_cache, ynodes, znodes)

        r_vec[i] = res[1][1]
        y_vec[i] = res[1][2]
        z_vec[i] = res[1][3]
        e_vec[i] = res[2]

        t = file["timeseries/t/$iter"]
        t_vec[i] = t
    end
    return t_vec, r_vec, y_vec, z_vec, e_vec
end
function save_results(results_dir, filename, t_vec, r_vec, y_vec, z_vec, e_vec)
    txt_filename = filename[1:end-4] * "txt"
    location = results_dir * "/" * txt_filename
    open(location, "w") do io
        writedlm(io, [t_vec r_vec y_vec z_vec e_vec])
    end
end
