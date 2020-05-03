clear;
close all;

%% ============== init params =============
mesh.H = 1;
mesh.g = 1;
mesh.v0 = sqrt(mesh.g * mesh.H);
mesh.T_period = 2*pi / mesh.v0;
mesh.Nx = 100;
mesh.Ny = 100;
mesh.dx = 2 * pi / mesh.Nx;
mesh.dy = 2 * pi / mesh.Ny;
mesh.dt = mesh.dx / mesh.v0 / 3;
mesh.Nt = round(15 * mesh.T_period / mesh.dt) + 1;

mesh.T = mesh.Nt * mesh.dt;
mesh.Lx = mesh.dx * mesh.Nx;
mesh.Ly = mesh.dy * mesh.Ny;

draw_evol = 1;
draw_err = 1;
mesh.x1 = mesh.Lx / 2;
mesh.y1 = mesh.Ly / 3;
mesh.sgm = mesh.Lx / 10;
mesh.ys_fnc = @(x)get_ys(x, mesh.y1, mesh.x1, mesh.sgm, mesh.Lx);
mesh.ys_derv_fnc = @(x)get_ys_derv(x, mesh.y1, mesh.x1, mesh.sgm, mesh.Lx);
mesh.w_lowerB_fnc = @(x)get_w_lowerB(x);
mesh.w_upperB_fnc = @(x)get_w_upperB(x);
mesh.y_fnc = @(x, eta)get_y(mesh.ys_fnc, x, eta, mesh.Ly);

%% =============== tests ================
mesh.grid = get_grid(mesh.ys_fnc, mesh.Nx, mesh.dx, mesh.Ny, mesh.dy);

getFig('x', 'y', 'grid');
surf(mesh.grid.Xu, mesh.grid.Yu, ones(size(mesh.grid.Xu)));

grid = get_init_state(mesh, 1);
getFig('x', 'y', 'u(x,y)');
surf(grid.Xu, get_y(ys_fnc, grid.Xu, grid.Eta_u, Ly), grid.u, 'EdgeColor', 'interp');
getFig('x', 'y', 'h(x,y)');
surf(grid.Xh, get_y(ys_fnc, grid.Xh, grid.Eta_h, Ly), grid.h, 'EdgeColor', 'interp');
getFig('x', 'y', 'w(x,y)');
surf(grid.Xw, get_y(ys_fnc, grid.Xw, grid.Eta_w, Ly), grid.w, 'EdgeColor', 'interp');

    
