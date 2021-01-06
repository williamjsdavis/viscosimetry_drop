circ_guess(y,z,r,y₀,z₀) = (r>sqrt((y-y₀)^2 + (z-z₀)^2))
function circ_error(data, circ_guess_data, yb, zb, r, y₀, z₀)
    circ_guess_in(y,z) = circ_guess(y,z,r,y₀,z₀)
    for (i, yy) in enumerate(yb), (j, zz) in enumerate(zb)
        circ_guess_data[i,j] = circ_guess_in(yy, zz)
        circ_guess_data[i,j] ⊻= data[i,j]
    end
    return reduce(+, circ_guess_data)
end
