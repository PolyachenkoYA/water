function d = diff_center_periodic(f, shft, dx)
    d = (circshift(f, shft) - circshift(f, -shft)) / (2 * dx);
end
