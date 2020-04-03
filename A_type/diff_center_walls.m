function d = diff_center_walls(f, shft, dx)
% isn't currently used
    d = (f((1 + 2*shft(1)) : (end            ), (1 + 2*shft(2)) : (end            )) - ...
         f((1            ) : (end - 2*shft(1)), (1            ) : (end - 2*shft(2)))) / (dx * 2);         
end
