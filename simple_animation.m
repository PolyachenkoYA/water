clear; close all;

%% ============== init params =============
H = 1;
g = 1;
l = 2*pi;
N = 100;
v0 = sqrt(g * H);
T = 100;
dt = 0.001;

T_period = 2*pi / v0;
Nt = round(T/dt);
dx = l/N;
dy = l/N;
[Y, X] = meshgrid((1:N) * dy, (1:N) * dx);

draw_evol = 1;
draw_err = 1;

%% =============== init state ===============
[h, u, v] = get_init_state(X, Y);

if(draw_evol)
    [fig, ax, leg] = getFig('x', 'y', 'h(x,y)', '', '', '', 'h');
    view(-37.5, 30);    
else
    ax = [];
end

%% =============== evolve =================
%[h, u, v, err] = evol_sys_to_T_1(g, H, T, dt, h, u, v, X, Y,...
%                    @diff_fwd_walls, @th_solution,...
%                    ax, ['dt = ' num2str(dt) '; dx = ' num2str(dx)]);
%[h, u, v, err] = evol_sys_to_T_2(g, H, T, dt, h, u, v, X, Y,...
%                    @step_fwd_walls, @step_center_walls, @th_solution,...
%                    ax, ['dt = ' num2str(dt) '; dx = ' num2str(dx)]);
[h, u, v, err] = evol_sys_to_T_2(g, H, T, dt, h, u, v, X, Y,...
                    @step_fwd_periodic, @step_center_periodic, @th_solution,...
                    ax, ['dt = ' num2str(dt) '; dx = ' num2str(dx)]); % works OK for diff_periodic


if(draw_err)
    getFig('t', '$< r^2 >$', 'err(t)', 'log', 'log');
    plot((1:Nt)*dt, err, 'DisplayName', 'error');
    plot([1, 1] * T_period, [1e-5, max(err) / 2], 'DisplayName', 'period');
end
