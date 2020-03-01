function d = diff_fwd_walls(f, shft, dx)
    d = (f((2 + shft(1)) : (end), (2 + shft(2)) : (end)) - ...
         f((2) : (end - shft(1)), (2) : (end - shft(2))) / dx;    
end
