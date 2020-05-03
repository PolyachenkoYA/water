clear;
close all;

%% ============== init params =============
H = 1;
g = 1;
v0 = sqrt(g * H);
T_period = 2*pi / v0;
Nx = 100;
Ny = 100;
dx = 2 * pi / Nx;
dy = 2 * pi / Ny;
dt = dx / v0 / 3;
%dt = 1e-3;
Nt = round(15 * T_period / dt) + 1;

T = Nt * dt;
lx = dx * Nx;
ly = dy * Ny;

draw_evol = 1;
draw_err = 1;
x1 = lx / 2;
y1 = ly / 3;
sgm = lx / 10;
ys_fnc = @(x)get_ys(x, y1, x1, sgm, lx);
ys_derv_fnc = @(x)get_ys_derv(x, y1, x1, sgm, lx);
w_lowerB_fnc = @(x)get_w_lowerB(x);
w_upperB_fnc = @(x)get_w_upperB(x);

%% =============== tests ================
[Xu, Xw, Xh, Eta_u, Eta_w, Eta_h, Yu, Yw, Yh] = ...
    get_grid(ys_fnc, Nx, dx, Nx, dx);


getFig('x', 'y', 'grid');
surf(Xu, Yu, ones(size(Xu)));

[h, u, w, Xu, Xw, Xh, Eta_u, Eta_w, Eta_h, Yu, Yw, Yh] = ...
    get_init_state(ys_fnc, ys_derv_fnc, w_lowerB_fnc, w_upperB_fnc,...
                   Nx, dx, Ny, dy, 1);
getFig('x', 'y', 'u(x,y)');
surf(Xu, get_y(ys_fnc, Xu, Eta_u, ly), u, 'EdgeColor', 'interp');
getFig('x', 'y', 'h(x,y)');
surf(Xh, get_y(ys_fnc, Xh, Eta_h, ly), h, 'EdgeColor', 'interp');
getFig('x', 'y', 'w(x,y)');
surf(Xw, get_y(ys_fnc, Xw, Eta_w, ly), w, 'EdgeColor', 'interp');

    
