function grid = get_grid(mesh)
    grid.xu = (0:1:(mesh.Nx - 1)) * mesh.dx;
    grid.eta_u = ((1:1:mesh.Ny) - 1/2) / mesh.Ny;
    [grid.Xu, grid.Eta_u] = meshgrid(grid.xu, grid.eta_u);    
    grid.Yu = mesh.y_fnc(grid.Xu, grid.Eta_u);
    grid.etaY_u = 1 ./ (mesh.Ly - mesh.ys_fnc(grid.Xu));
    grid.su = mesh.ys_derv_fnc(grid.Xu) .* (1 - grid.Eta_u);
    
    grid.xv = ((1:1:mesh.Nx) - 1/2) * mesh.dx;
    grid.eta_v = (0:1:mesh.Ny) / mesh.Ny;
    [grid.Xw, grid.Eta_w] = meshgrid(grid.xv, grid.eta_v);
    grid.Yw = mesh.y_fnc(grid.Xw, grid.Eta_w);
    grid.etaY_w = 1 ./ (mesh.Ly - mesh.ys_fnc(grid.Xw));    
    grid.sw = zeros(mesh.Ny + 1, mesh.Nx);
    grid.sw(2:(end-1), :) = mesh.ys_derv_fnc(grid.Xw(2:(end-1), :)) .* (1 - grid.Eta_w(2:(end-1), :));
    grid.sw(1, :) = mesh.w_lowerBderv_fnc(grid.Xw(1, :));
    grid.sw(end, :) = mesh.w_lowerBderv_fnc(grid.Xw(end, :));
        
    grid.xh = ((1:1:mesh.Nx) - 1/2) * mesh.dx;
    grid.eta_h = ((1:1:mesh.Ny) - 1/2) / mesh.Ny;
    [grid.Xh, grid.Eta_h] = meshgrid(grid.xh, grid.eta_h);
    grid.Yh = mesh.y_fnc(grid.Xh, grid.Eta_h);
    grid.etaY_h = 1 ./ (mesh.Ly - mesh.ys_fnc(grid.Xh));            
    grid.sh = mesh.ys_derv_fnc(grid.Xh) .* (1 - grid.Eta_h);
end