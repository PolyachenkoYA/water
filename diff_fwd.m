function d = diff_fwd(f, shft, dx)
    d = (circshift(f, shft) - circshift(f, zeros(size(shft)))) / dx;
end
