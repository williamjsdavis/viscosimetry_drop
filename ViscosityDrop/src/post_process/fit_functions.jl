struct ParameterGrid2D
    r_range::StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
    y₀_range::StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
    z₀_range::StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
end
ParameterGrid2D(Ly::Number, Lz::Number, Ncourse::Int) = begin
    ParameterGrid2D(range(0,Ly/2,length=Ncourse),
                    range(-Ly/2,Ly/2,length=Ncourse),
                    range(-Lz,0,length=Ncourse))
end
function grid_search(pgrid::ParameterGrid2D, bitmap_input, guess_cache, ynodes, znodes)
    i_loc, j_loc, k_loc = 1, 1, 1

    val_min = circ_error(bitmap_input, guess_cache, ynodes, znodes,
            pgrid.r_range[1], pgrid.y₀_range[1], pgrid.z₀_range[1])
    for (i, r) in enumerate(pgrid.r_range)
        for (j, y) in enumerate(pgrid.y₀_range)
            for (k, z) in enumerate(pgrid.z₀_range)
                err = circ_error(bitmap_input, guess_cache, ynodes, znodes, r, y, z)
                if err < val_min
                    val_min = err
                    i_loc, j_loc, k_loc = i, j, k
                end
            end
        end
    end
    return (i_loc, j_loc, k_loc), val_min
end
function coarse_fine_search(pgrid::ParameterGrid2D, bitmap_input, guess_cache, ynodes, znodes)
    # Coarse search
    res_course = grid_search(pgrid, bitmap_input, guess_cache, ynodes, znodes)

    # Fine search
    to_minim(x) = circ_error(bitmap_input, guess_cache, ynodes, znodes, x[1], x[2], x[3])
    x0 = [pgrid.r_range[res_course[1][1]],
          pgrid.y₀_range[res_course[1][2]],
          pgrid.z₀_range[res_course[1][3]]]
    res = optimize(to_minim, x0)

    return res.minimizer, res.minimum, x0
end
