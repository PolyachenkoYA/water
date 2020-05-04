clear; close all;

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

%% =============== init state ===============
[h, u, v] = get_init_state(Nx, dx, Ny, dy, 2);

figs = getInitFigs(draw_evol, draw_err);

%% =============== evolve =================
lbl = ['dt = ' num2str(dt) '; dx = ' num2str(dx)];
if(draw_err)
    [h, u, v, err] = ...
        evol_sys_to_T_1(g, H, u, v, h, Nt, dt, dx, dy,...
                        @derivative_fun_walls, @step_RK4, lbl,...
                        figs, draw_evol, @th_cos_solution);
else
   [h, u, v, err] = ...
       evol_sys_to_T_1(g, H, u, v, h, Nt, dt, dx, dy,...
                       @derivative_fun_walls, @step_RK4, ...
                       lbl, figs, draw_evol);
end

if(any(err ~= 0))
    getFig('t', '$\sqrt{< r^2 >_{x}}$', 'err(t)', 'log', 'log');
    plot((1:Nt)*dt, err, 'DisplayName', 'error');
    plot([1, 1] * T_period, [1e-5, max(err) / 2], 'DisplayName', 'period');
end
