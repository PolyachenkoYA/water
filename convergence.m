%clear; close all;

%% ============== init params =============
H = 1;
g = 1;
l = 2*pi;
N = 100;
v0 = sqrt(g * H);
T_period = l / v0;
T = T_period * (1 - 1/8);
%T = 0.1;
dt = 1e-3;
dt_err_filename = 'err_dt';
dx_err_filename = 'err_dx';

draw_evol = 0;
need_to_recomp = 0;
draw_err = 1;
save_res = 1;
N_dt = 0;
dt_lims = [-2.5, -3.5];
N_dx = 4;
dx_lims = [-1, -2.5];
data_path = 'convergence/data';

%% =============== actual work =================
dt_arr = 10.^linspace(dt_lims(1), dt_lims(2), N_dt);
dt_arr = [0.003, 0.001, 0.0003];
T = next_divisible(round(T / min(dt_arr)), lcms([3, 10, 30])) * min(dt_arr);
dx_arr = 10.^linspace(dx_lims(1), dx_lims(2), N_dx)';
filename = ['T' num2str(T) '_Ndx' num2str(N_dx) '_dxlims' num2str(dx_lims(1)) '-' num2str(dx_lims(2))...
           '_Ndt' num2str(N_dt) '_dtLims' num2str(-dt_lims(1)) '-' num2str(-dt_lims(2)) '.mat'];
filename = fullfile(pwd, data_path, filename);
if(~need_to_recomp && exist(filename, 'file'))
    load(filename, dt_err_filename, dx_err_filename);
else
    err_dx = zeros(N_dx, 1);
    if(N_dx > 0)        
        %dt = 1e-3;
        %parfor N_i = 1:N_dx
        for dx_i = 1:N_dx
            [fig_h, ax_h, leg_h, fig_v, ax_v, leg_v, fig_dh, ax_dh, leg_dh] = ...
                getInitFigs(draw_evol, draw_err);
            disp(['N_i proc: ' num2str(dx_i/N_dx)]);
            dx = dx_arr(dx_i);
            dy = dx;
            dt = dx / v0 / 3;
            N = round(l / dx);
            [h, u, v] = get_init_state(N, dx, N, dy, 2);    
            lbl = ['dt = 10^{' num2str(log(dt)/log(10)) '}; dx = 10^{' num2str(log(dx_arr(dx_i))/log(10)) '}'];
            [~, ~, ~, err] = ...
                evol_sys_to_T_2(g, H, u, v, h,...
                              round(T/dt), dt, dx, dy,...
                              @step_fwd_walls, @step_center_walls, lbl, ax_h, ax_v, ax_dh,...
                              @th_cos_solution);
            
            err_dx(dx_i) = err(end);
            disp([lbl ' : err = ' num2str(err_dx(dx_i))]);
            if(draw_err)
                getFig('t', '$\langle r \rangle$', ['$err(t) | ' lbl '$'], 'log', 'log');
                plot((1:length(err)) * dt, err);
                plot([1, 1] * T_period, [1e-5, max(err) / 2], 'DisplayName', 'period');
                pause(0.001);
            end
        end   
    end
    
    err_dt = zeros(N_dt, 1);
    if(N_dt > 0)                
        dx = l / 300;
        dy = dx;        
        %parfor dt_i = 1:N_dt
        for dt_i = 1:N_dt
            [fig_h, ax_h, leg_h, fig_v, ax_v, leg_v, fig_dh, ax_dh, leg_dh] = ...
                getInitFigs(draw_evol, draw_err);
            disp(['dt_i proc: ' num2str(dt_i/N_dt)]);
            N = round(l/dx);
            [h, u, v] = get_init_state(N, dx, N, dy, 2);       
            lbl = ['dt = 10^{' num2str(log(dt_arr(dt_i))/log(10)) '}; dx = 10^{' num2str(log(l/N)/log(10)) '}'];
            [~, ~, ~, err] = ...
                evol_sys_to_T_2(g, H, u, v, h,...
                              round(T/dt_arr(dt_i)), dt_arr(dt_i), dx, dy,...
                              @step_fwd_walls, @step_center_walls, lbl, ax_h, ax_v, ax_dh,...
                              @th_cos_solution);
            err_dt(dt_i) = err(end);
            disp([lbl ' : err = ' num2str(err_dt(dt_i))]);
            if(draw_evol)
                close(fig_h);
                close(fig_v);
            end            
            if(draw_err)
                getFig('t', '$\langle r \rangle$', ['$err(t) | ' lbl '$'], 'log', 'log');
                plot((1:length(err)) * dt_arr(dt_i), err);
                plot([1, 1] * T_period, [1e-5, max(err) / 2], 'DisplayName', 'period');
                pause(0.001);
            end
        end
    end
        
    if(save_res)
        save(filename, dt_err_filename, dx_err_filename);
    end
end

if(N_dt > 0)
    getFig('dt', 'err', ['err(dt), T = ' num2str(T)], 'log', 'log');
    plot(dt_arr, err_dt, 'o', 'LineWidth', 2);
end

if(N_dx > 0)
    pfit = polyfit(log(dx_arr), log(err_dx), 1);
    getFig('dx', 'err', ['err(dx), T = ' num2str(T) '; k = ' num2str(pfit(1))], 'log', 'log');
    plot(dx_arr, err_dx, 'o', 'LineWidth', 2);
end

function b = next_divisible(a, n)
    b = a + (n - rem(a,n));
end
