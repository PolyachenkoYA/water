clear; close all;

% stability dt/dx < 1

%% ============== init params =============
H = 1;
g = 1;
l = 2*pi/10;
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
N_dt = 3;
dt_lims = [-2.5, -3.5];
N_dx = 0;
dx_lims = [-2, -3];
data_path = 'data';

%% =============== actual work =================
if(N_dt > 0)
    dt_arr = 10.^linspace(dt_lims(1), dt_lims(2), N_dt);
    dt_arr = [0.01, 0.003, 0.001];
    dt_arr = [0.01, 0.0095, 0.009, 0.008, 0.005];
    %dt_arr = [0.01, 0.005];
    N_dt = length(dt_arr);
    T = next_divisible(round(T / min(dt_arr)), lcms([100, 95, 90, 80])) * min(dt_arr);
end
dx_arr = 10.^linspace(dx_lims(1), dx_lims(2), N_dx)';
filename = ['T' num2str(T) '_Ndx' num2str(N_dx) '_dxlims' num2str(dx_lims(1)) '-' num2str(dx_lims(2))...
           '_Ndt' num2str(N_dt) '_dtLims' num2str(-dt_lims(1)) '-' num2str(-dt_lims(2)) '.mat'];
filename = fullfile(pwd, data_path, filename);
if(~need_to_recomp && exist(filename, 'file'))
    load(filename, dt_err_filename, dx_err_filename);
else
    err_dx = zeros(N_dx, 1);
    if(N_dx > 0)        
        dt = min(dx_arr) / v0 / 1.1;
        %parfor N_i = 1:N_dx
        for dx_i = 1:N_dx
            figs = getInitFigs(draw_evol, draw_err);
            disp(['N_i proc: ' num2str(dx_i/N_dx)]);
            dx = dx_arr(dx_i);
            dy = dx;
            N = round(l / dx);
            [h, u, v] = get_init_state(N, dx, N, dy, 2);    
            lbl = ['dt = 10^{' num2str(log(dt)/log(10)) '}; dx = 10^{' num2str(log(dx_arr(dx_i))/log(10)) '}'];
            [~, ~, ~, err] = ...
                evol_sys_to_T_1(g, H, u, v, h, round(T/dt), dt, dx, dy,...
                        @derivative_fun_walls, @step_RK4, lbl,...
                        figs, draw_evol, @th_cos_solution);                          
            
            err_dx(dx_i) = err(end);
            disp([lbl ' : err = ' num2str(err_dx(dx_i))]);
            if(draw_err)
                fig_err = getFig('t', '$\langle r \rangle$', ['$err(t) | ' lbl '$'], 'log', 'log');
                plot(fig_err.ax, (1:length(err)) * dt, err);
                plot(fig_err.ax, [1, 1] * T_period, [1e-5, max(err) / 2], 'DisplayName', 'period');
                pause(0.001);
            end
        end   
    end
    
    err_dt = zeros(N_dt, 1);
    if(N_dt > 0)                
        %dx = l / 500;
        dx = max(dt_arr) * 1.5 * v0;
        dy = dx;        
        %parfor dt_i = 1:N_dt
        for dt_i = 1:N_dt
            figs = getInitFigs(draw_evol, draw_err);
            disp(['dt_i proc: ' num2str(dt_i/N_dt)]);
            N = round(l/dx);
            [h, u, v] = get_init_state(N, dx, N, dy, 2);       
            lbl = ['dt = 10^{' num2str(log(dt_arr(dt_i))/log(10)) '}; dx = 10^{' num2str(log(l/N)/log(10)) '}'];
            [~, ~, ~, err] = ...
                evol_sys_to_T_1(g, H, u, v, h, ...
                                round(T/dt_arr(dt_i)), dt_arr(dt_i), dx, dy,...
                                @derivative_fun_walls, @step_RK4, lbl,...
                                figs, draw_evol, @th_cos_solution);                          
                          
            err_dt(dt_i) = err(end);
            disp([lbl ' : err = ' num2str(err_dt(dt_i))]);
            if(draw_evol)
                close(figs.fig_h);
                close(figs.fig_v);
            end            
            if(draw_err)
                fig_err = getFig('t', '$\sqrt{\langle r^2 \rangle_x}$', ['$err(t) | ' lbl '$'], 'log', 'log');
                plot(fig_err.ax, (1:length(err)) * dt_arr(dt_i), err);
                plot(fig_err.ax, [1, 1] * T_period, [1e-5, max(err) / 2], 'DisplayName', 'period');
                pause(0.001);
            end
        end
    end
        
    if(save_res)
        save(filename, dt_err_filename, dx_err_filename);
    end
end

if(N_dt > 0)
    %getFig('$dt$', 'err', ['err(dt), T = ' num2str(T)], 'log', 'log');
    %plot(dt_arr, err_dt, 'o', 'LineWidth', 2);

    x_draw = dt_arr.^4;
    linfit_dt = polyfit(x_draw, err_dt, 1);
    getFig('$dt^4$', 'err', ['err(dt), T = ' num2str(T) '; k = ' num2str(linfit_dt(1))]);
    plot(x_draw, err_dt, 'o', 'LineWidth', 2, 'DisplayName', 'data');
    plot(x_draw, polyval(linfit_dt, x_draw), 'DisplayName', 'linfit');
end

if(N_dx > 0)
    logfit_dx = polyfit(log(dx_arr), log(err_dx), 1);
    getFig('$dx$', 'err', ['err(dx), T = ' num2str(T) '; k = ' num2str(logfit_dx(1))], 'log', 'log');
    plot(dx_arr, err_dx, 'o', 'LineWidth', 2, 'DisplayName', 'data');
    plot(dx_arr, exp(polyval(logfit_dx, log(dx_arr))), 'DisplayName', 'linfit');    
    
    x_draw = dx_arr.^2;
    linfit_dx = polyfit(x_draw, err_dx, 1);
    getFig('$dx^2$', 'err', ['err(dx), T = ' num2str(T) '; k = ' num2str(linfit_dx(1))], 'log', 'log');
    plot(x_draw, err_dx, 'o', 'LineWidth', 2, 'DisplayName', 'data');
    plot(x_draw, polyval(linfit_dx, x_draw), 'DisplayName', 'linfit');
end

function b = next_divisible(a, n)
    b = a + (n - rem(a,n));
end
