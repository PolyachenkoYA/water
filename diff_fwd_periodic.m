function d = diff_fwd_periodic(f, shft, dx)
    d = (circshift(f, shft) - f) / dx;
end
