function [Xu, Xw, Xh, Eta_u, Eta_w, Eta_h, Yu, Yw, Yh] = ...
             get_grid(ys_fnc, Nx, dx, Ny, dy)
    y0 = dy * Ny;
    
    xu = (0:1:Nx) * dx;
    eta_u = ((1:1:Ny) - 1/2) / Ny;
    [Xu, Eta_u] = meshgrid(xu, eta_u);    
    Yu = get_y(ys_fnc, Xu, Eta_u, y0);
    
    xv = ((1:1:Nx) - 1/2) * dx;
    eta_v = (0:1:Ny) / Ny;
    [Xw, Eta_w] = meshgrid(xv, eta_v);
    Yw = get_y(ys_fnc, Xw, Eta_w, y0);
        
    xh = ((1:1:Nx) - 1/2) * dx;
    eta_h = ((1:1:Ny) - 1/2) / Ny;
    [Xh, Eta_h] = meshgrid(xh, eta_h);
    Yh = get_y(ys_fnc, Xh, Eta_h, y0);
end