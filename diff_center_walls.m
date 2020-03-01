function d = diff_center_walls(f, shft, dx)
    d = (f((2 + shft(1)) : (end - 1 + shft(1)), (2 + shft(2)) : (end - 1 + shft(2))) - ...
         f((2 - shft(1)) : (end - 1 - shft(1)), (2 - shft(2)) : (end - 1 - shft(2)))) / (2 * dx);
end
