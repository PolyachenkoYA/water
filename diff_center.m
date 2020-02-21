function d = diff_center(f, shft, dx)
    d = (circshift(f, shft) - circshift(f, -shft)) / dx;
end
