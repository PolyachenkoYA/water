function d = diff_fwd_periodic(f, shft, dx)
    d = (circshift(f, shft) - circshift(f, zeros(size(shft)))) / dx;
end
