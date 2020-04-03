clear; close all;

%% ============== init params =============
H = 1;
g = 1;
l = 2*pi;
N = 100;
v0 = sqrt(g * H);
T_period = 2*pi / v0;
T = T_period * (1 - 1/8);
dt = 1e-3;

need_to_recomp = 1;
draw_err = 0;
save_res = 1;
N_dt = 3;
dt_lims = [-3, -4];
N_N = 3;
N_lims = [2, 3];
data_path = 'convergence/data';

%Nt = round(T/dt);
%dx = l/N;
%dy = l/N;
%[Y, X] = meshgrid((1:N) * dy, (1:N) * dx);

%% =============== actual work =================
dt_arr = 10.^linspace(dt_lims(1), dt_lims(2), N_dt);
N_arr = round(10.^linspace(N_lims(1), N_lims(2), N_N));
filename = ['T' num2str(T) '_NN' num2str(N_N) '_Nlims' num2str(N_lims(1)) '-' num2str(N_lims(2))...
           '_Ndt' num2str(N_dt) '_dtLims' num2str(-dt_lims(1)) '-' num2str(-dt_lims(2)) '.mat'];
filename = fullfile(pwd, data_path, filename);
if(~need_to_recomp && exist(filename, 'file'))
    load(filename, 'err_dt', 'err_N');
else
    err_N = zeros(N_N, 1);
    if(N_N > 0)        
        %parfor N_i = 1:N_N
        for N_i = 1:N_N
            disp(['N_i proc: ' num2str(N_i/N_N)]);
            dx = l/N_arr(N_i);
            dy = l/N_arr(N_i);
            dt = dx/3/v0;
            [Y, X] = meshgrid((1:N_arr(N_i)) * dx, (1:N_arr(N_i)) * dy);
            [h, u, v] = get_init_state(X, Y);    
            lbl = ['dt = 10^{' num2str(log(dt)/log(10)) '}; dx = 10^{' num2str(log(N_arr(N_i))/log(10)) '}'];
            [~, ~, ~, err] = evol_sys_to_T(lbl, g, H, T, dt, h, u, v, X, Y, @th_solution, []);
            err_N(N_i) = err(end);
            if(draw_err)
                getFig('N', '$\langle r \rangle$', ['$err(t) | ' lbl '$'], 'log', 'log');
                plot((1:length(err)) * N_arr(N_i), err);
                legend off;
                pause(0.001);
            end
        end   
    end
    
    err_dt = zeros(N_dt, 1);
    if(N_dt > 0)                
        %parfor dt_i = 1:N_dt
        for dt_i = 1:N_dt
            disp(['dt_i proc: ' num2str(dt_i/N_dt)]);
            N = l/(3 * v0 * dt_arr(dt_i));
            [Y, X] = meshgrid((1:N) * l/N, (1:N) * l/N);
            [h, u, v] = get_init_state(X, Y);    
            lbl = ['dt = 10^{' num2str(log(dt_arr(dt_i))/log(10)) '}; dx = 10^{' num2str(log(N)/log(10)) '}'];
            [~, ~, ~, err] = evol_sys_to_T(lbl, g, H, T, dt_arr(dt_i), h, u, v, X, Y, @th_solution, []);
            err_dt(dt_i) = err(end);
            if(draw_err)
                getFig('t', '$\langle r \rangle$', ['$err(t) | ' lbl '$'], 'log', 'log');
                plot((1:length(err)) * dt_arr(dt_i), err);
                legend off;
                pause(0.001);
            end
        end
    end
        
    if(save_res)
        save(filename, 'err_dt', 'err_N');
    end
end

if(N_dt > 0)
    getFig('dt', 'err', ['err(dt), T = ' num2str(T)], 'log', 'log');
    plot(dt_arr, err_dt, 'o', 'LineWidth', 2);
end

if(N_N > 0)
    getFig('dx', 'err', ['err(dx), T = ' num2str(T)], 'log', 'log');
    plot(l ./ N_arr, err_N, 'o', 'LineWidth', 2);
end
