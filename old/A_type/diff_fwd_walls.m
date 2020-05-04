function d = diff_fwd_walls(f, shft, dx)
    d = (f((1 + 2*shft(1)) : (end          ), (1 + 2*shft(2)) : (end          )) - ...
         f((1 +   shft(1)) : (end - shft(1)), (1 +   shft(2)) : (end - shft(2)))) / dx;    
end
