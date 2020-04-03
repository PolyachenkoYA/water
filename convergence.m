clear; close all;

%% ============== init params =============
H = 1;
g = 1;
l = 2*pi;
N = 100;
v0 = sqrt(g * H);
T_period = 2*pi / v0;
T = T_period * (1 + 1/8);
%T = 0.1;
dt = 1e-3;
draw_evol = 0;
dt_err_filename = 'err_dt';
dx_err_filename = 'err_dx';

need_to_recomp = 0;
draw_err = 1;
save_res = 1;
N_dt = 3;
dt_lims = [-3, -4];
N_dx = 3;
dx_lims = [-1, -2];
data_path = 'convergence/data';

%Nt = round(T/dt);
%dx = l/N;
%dy = l/N;
%[Y, X] = meshgrid((1:N) * dy, (1:N) * dx);

%% =============== actual work =================
dt_arr = 10.^linspace(dt_lims(1), dt_lims(2), N_dt);
dx_arr = 10.^linspace(dx_lims(1), dx_lims(2), N_dx);
filename = ['T' num2str(T) '_Ndx' num2str(N_dx) '_dxlims' num2str(dx_lims(1)) '-' num2str(dx_lims(2))...
           '_Ndt' num2str(N_dt) '_dtLims' num2str(-dt_lims(1)) '-' num2str(-dt_lims(2)) '.mat'];
filename = fullfile(pwd, data_path, filename);
if(~need_to_recomp && exist(filename, 'file'))
    load(filename, dt_err_filename, dx_err_filename);
else
    err_dx = zeros(N_dx, 1);
    if(N_dx > 0)        
        dt = 3e-4;
        %parfor N_i = 1:N_dx
        for dx_i = 1:N_dx
            if(draw_evol)
                [fig, ax] = getFig('x', 'z');
                view(-37.5, 30);   
            else
                ax = [];
            end
            disp(['N_i proc: ' num2str(dx_i/N_dx)]);
            dx = dx_arr(dx_i);
            dy = dx;
            %dt = dx/v0/100;
            N = round(l / dx) + 1;
            %[Y, X] = meshgrid((1:N_arr(N_i)) * dx, (1:N_arr(N_i)) * dy);
            [h, u, v] = get_init_state(N, dx, N, dy, 2);    
            lbl = ['dt = 10^{' num2str(log(dt)/log(10)) '}; dx = 10^{' num2str(log(dx_arr(dx_i))/log(10)) '}'];
            [~, ~, ~, err] = evol_sys_to_T(g, H, u, v, h, round(T/dt) + 1, dt, dx, dy,...
                                           @step_fwd_walls, lbl,...
                                           ax, @th_cos_solution);
            
            err_dx(dx_i) = err(end);
            disp([lbl ' : err = ' num2str(err_dx(dx_i))]);
            if(draw_evol)
                close(fig);
            end
            if(draw_err)
                getFig('t', '$\langle r \rangle$', ['$err(t) | ' lbl '$'], 'log', 'log');
                plot((1:length(err)) * dt, err);
                plot([1, 1] * T_period, [1e-5, max(err) / 2], 'DisplayName', 'period');
                %legend off;
                pause(0.001);
            end
        end   
    end
    
    err_dt = zeros(N_dt, 1);
    if(N_dt > 0)                
        dx = 0.02;
        dy = dx;        
        %parfor dt_i = 1:N_dt
        for dt_i = 1:N_dt
            if(draw_evol)
                [fig, ax] = getFig('x', 'z');
                view(-37.5, 30);   
            else
                ax = [];
            end            
            disp(['dt_i proc: ' num2str(dt_i/N_dt)]);
            N = round(l/dx) + 1;
            %[Y, X] = meshgrid((1:N) * l/N, (1:N) * l/N);
            [h, u, v] = get_init_state(N, dx, N, dy, 2);       
            lbl = ['dt = 10^{' num2str(log(dt_arr(dt_i))/log(10)) '}; dx = 10^{' num2str(log(l/N)/log(10)) '}'];
            [~, ~, ~, err] = evol_sys_to_T(g, H, u, v, h, round(T/dt_arr(dt_i)) + 1, dt_arr(dt_i), dx, dy,...
                                           @step_fwd_walls, lbl,...
                                           [], @th_cos_solution);
            err_dt(dt_i) = err(end);
            disp([lbl ' : err = ' num2str(err_dt(dt_i))]);
            if(draw_evol)
                close(fig);
            end            
            if(draw_err)
                getFig('t', '$\langle r \rangle$', ['$err(t) | ' lbl '$'], 'log', 'log');
                plot((1:length(err)) * dt_arr(dt_i), err);
                plot([1, 1] * T_period, [1e-5, max(err) / 2], 'DisplayName', 'period');
                %legend off;
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
    getFig('dx', 'err', ['err(dx), T = ' num2str(T)], 'log', 'log');
    plot(dx_arr, err_dx, 'o', 'LineWidth', 2);
end