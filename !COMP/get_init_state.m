function [mesh, grid, state] = get_init_state(mesh, mode)
    state.u = zeros(mesh.Ny, mesh.Nx);
    state.v = zeros(mesh.Ny + 1, mesh.Nx);
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
            state.hmax = 1;
            state.umax = 1/3;
            state.vmax = 0;
    end
    
    mesh.restore_v = @(state)get_restored_v(grid, state);
    mesh.th_solution = @(t)th_cos_solution(mesh, grid.Xh, grid.Yh, t);    
    mesh.restore_w = @(state)get_restored_w(mesh, grid, state);
    mesh.derivative_fun = @(state)derivative_fun_walls(mesh, grid, state);    
    mesh.step_fwd = @(state)step_RK4(mesh, grid, state);    
    
    state = mesh.restore_w(state);
    mesh.maxVinit = state.maxV;
end