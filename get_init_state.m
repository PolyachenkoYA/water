function [h, u, w, Xu, Xw, Xh, Eta_u, Eta_w, Eta_h, Yu, Yw, Yh] = ...
           get_init_state(ys_fnc, ys_derv_fnc, w_lowerB_fnc, w_upperB_fnc, ...
                          Nx, dx, Ny, dy, mode) 
    u = zeros(Ny, Nx + 1);
    v = zeros(Ny + 1, Nx);
    w = zeros(Ny + 1, Nx);
    h = zeros(Ny, Nx);
    lx = Nx * dx;
    ly = Ny * dy;
    
    [Xu, Xw, Xh, Eta_u, Eta_w, Eta_h, Yu, Yw, Yh] = ...
        get_grid(ys_fnc, Nx, dx, Ny, dy);
    
    switch(mode)
        case 1            
            u = exp(-(((Xu - lx/8) / (lx*10)).^2 + ((Yu - ly/2) / (ly*10)).^2)) .* ...
                ((Yu - dy/2) .* (Xu) .* (ly - dy/2 - Yu) .* max((lx/3 - Xu),0)).^2;
            h = exp(-(((Xh - lx/8) / (lx/10)).^2 + ((Yh - ly/2) / (ly/2)).^2)) .* ...
                ((Yh - dy/2) .* (Xh - dx/2) .* (ly - dy/2 - Yh) .* (lx - dx/2 - Xh)).^2;
            
            h = h / max(h, [], 'all');
            u = u / max(u, [], 'all') / 3; 
    end
    
    w(1, :) = w_lowerB_fnc(Xw(1, :));
    w(end, :) = w_upperB_fnc(Xw(end, :));
    u_forW = (u(1:(end-1), 1:(end-1)) + u(1:(end-1), 1:(end-1)) + ...
              u(2:(end), 1:(end-1)) + u(2:(end), 2:(end))) / 4;
    s = ys_derv_fnc(Xw(2:(end-1), :)) .* (1 - Eta_w(2:(end-1), :));
    w(2:(end-1), :) = (v(2:(end-1), :) - u_forW .* s) ./ sqrt(1 + s.^2);
end