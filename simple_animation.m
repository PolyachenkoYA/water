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
dt = 1e-3;
Nt = round(5 * T_period / dt) + 1;

T = Nt * dt;
lx = dx * Nx;
ly = dy * Ny;

draw_evol = 1;
draw_err = 1;

%% =============== init state ===============
[h, u, v] = get_init_state(Nx, dx, Ny, dy, 2);

if(draw_evol)
    [fig_h, ax_h, leg_h] = getFig('x', 'y', 'h(x,y)', '', '', '', 'h');
    view(-37.5, 30);    
    
    if(draw_err)
        [fig_dh, ax_dh, leg_dh] = getFig('x', 'y', 'dh(x,y)', '', '', '', 'dh');
        view(-37.5, 30);        
    end
    
    [fig_v, ax_v, leg_v] = getFig('x', 'y', '$\vec{v}(x,y)$');
else
    ax_h = [];
    ax_v = [];
end

%% =============== evolve =================
lbl = ['dt = ' num2str(dt) '; dx = ' num2str(dx)];
if(draw_err)
%     [h, u, v, err] = evol_sys_to_T_1(g, H, u, v, h, Nt, dt, dx, dy,...
%                         @step_fwd_walls, lbl,...
%                         ax_h, ax_v, @th_cos_solution);
    [h, u, v, err] = evol_sys_to_T_2(g, H, u, v, h, Nt, dt, dx, dy,...
                        @step_fwd_walls, @step_center_walls, lbl,...
                        ax_h, ax_v, ax_dh, @th_cos_solution);
else
%    [h, u, v, err] = evol_sys_to_T_1(g, H, u, v, h, Nt, dt, dx, dy,...
%                        @step_fwd_walls, lbl,...
%                        ax_h, ax_v);    
    [h, u, v, err] = evol_sys_to_T_2(g, H, u, v, h, Nt, dt, dx, dy,...
                        @step_fwd_walls, @step_center_walls, lbl,...
                        ax_h, ax_v);                    
end

if(any(err ~= 0))
    getFig('t', '$< r^2 >$', 'err(t)', 'log', 'log');
    plot((1:Nt)*dt, err, 'DisplayName', 'error');
    plot([1, 1] * T_period, [1e-5, max(err) / 2], 'DisplayName', 'period');
end
