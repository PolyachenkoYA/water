%function [h, u, w, Xu, Xw, Xh, Eta_u, Eta_w, Eta_h, Yu, Yw, Yh] = ...
%            get_init_state(ys_fnc, ys_derv_fnc, w_lowerB_fnc, w_upperB_fnc, ...
%                           Nx, dx, Ny, dy, mode) 
function [state, grid] = get_init_state(mesh, mode)
    state.u = zeros(mesh.Ny, mesh.Nx);
    v = zeros(mesh.Ny + 1, mesh.Nx);
    state.w = zeros(mesh.Ny + 1, mesh.Nx);
    state.h = zeros(mesh.Ny, mesh.Nx);
    
    grid = get_grid(mesh);
    
    switch(mode)
        case 1            
            state.u = exp(-(((grid.Xu - mesh.Lx/8) / (mesh.Lx*10)).^2 + ((grid.Yu - mesh.Ly/2) / (mesh.Ly*10)).^2)) .* ...
                ((grid.Yu - mesh.dy/2) .* (grid.Xu) .* (mesh.Ly - mesh.dy/2 - grid.Yu) .* max((mesh.Lx/3 - grid.Xu), 0)).^2;
            state.h = exp(-(((grid.Xh - mesh.Lx/8) / (mesh.Lx/10)).^2 + ((grid.Yh - mesh.Ly/2) / (mesh.Ly/2)).^2)) .* ...
                ((grid.Yh - mesh.dy/2) .* (grid.Xh - mesh.dx/2) .* (mesh.Ly - mesh.dy/2 - grid.Yh) .* (mesh.Lx - mesh.dx/2 - grid.Xh)).^2;
            
            state.h = state.h / max(state.h, [], 'all');
            state.u = state.u / max(state.u, [], 'all') / 3; 
    end
    
    state.w(1, :) = mesh.w_lowerB_fnc(grid.Xw(1, :));
    state.w(end, :) = mesh.w_upperB_fnc(grid.Xw(end, :));
    state.u(:, end + 1) = state.u(:, 1);                                     % PBC
    u_forW = (state.u(1:(end-1), 1:(end-1)) + state.u(1:(end-1), 1:(end-1)) + ...
              state.u(2:(end), 1:(end-1)) + state.u(2:(end), 2:(end))) / 4;
    state.u(:, end) = [];                                                    % PBC
    state.w(2:(end-1), :) = (v(2:(end-1), :) - u_forW .* grid.s) ./ sqrt(1 + grid.s .^2);
end