function [ht, ut, vt] = derivative_fun_walls(g, H, h, u, v, dx, dy)
    [Ny, Nx] = size(h);

    ut = zeros(Ny, Nx + 1);
    ut(:, 2:(end-1)) = -(g / dx) * diff(h, 1, 2);
    
    vt = zeros(Ny + 1, Nx);
    vt(2:(end-1), :) = -(g / dy) * diff(h, 1, 1); % Y points downwards
    
    ht = -(H) * (diff(u, 1, 2)/dx + diff(v, 1, 1)/dy);        
end

