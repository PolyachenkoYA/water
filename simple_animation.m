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
dt = dx / v0 / 2 / 100;
Nt = round(2.5 * T_period / dt) + 1;

T = Nt * dt;
lx = dx * Nx;
ly = dy * Ny;

draw_evol = 0;
draw_err = 1;

%% =============== init state ===============
[h, u, v] = get_init_state(Nx, dx, Ny, dy, 2);

if(draw_evol)
    [fig, ax, leg] = getFig('x', 'y', 'h(x,y)', '', '', '', 'h');
    view(-37.5, 30);    
else
    ax = [];
end

%% =============== evolve =================
if(draw_err)
    [h, u, v, err] = evol_sys_to_T(g, H, u, v, h, Nt, dt, dx, dy,...
                        @step_fwd_walls, ['dt = ' num2str(dt) '; dx = ' num2str(dx)],...
                        ax, @th_cos_solution);
else
    [h, u, v, err] = evol_sys_to_T(g, H, u, v, h, Nt, dt, dx, dy,...
                        @step_fwd_walls, ['dt = ' num2str(dt) '; dx = ' num2str(dx)],...
                        ax);    
end

if(any(err ~= 0))
    getFig('t', '$< r^2 >$', 'err(t)', 'log', 'log');
    plot((1:Nt)*dt, err, 'DisplayName', 'error');
    plot([1, 1] * T_period, [1e-5, max(err) / 2], 'DisplayName', 'period');
end
