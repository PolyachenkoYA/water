clear; close all;

%% ============== init params =============
H = 1;
g = 1;
l = 2*pi;
N = 100;
v0 = sqrt(g * H);
T_period = 2*pi / v0;
T = T_period * (1 - 1/8);
dt = 0.01;

need_to_recomp = 0;
draw_err = 0;
save_res = 1;
N_dt = 3;
dt_lims = [-3, -4];
data_path = 'convergence/data';

Nt = round(T/dt);
dx = l/N;
dy = l/N;
[Y, X] = meshgrid((1:N) * dy, (1:N) * dx);

%% =============== actual work =================
dt_arr = 10.^linspace(dt_lims(1), dt_lims(2), N_dt);
filename = ['N' num2str(N) '_T' num2str(T) '_dt' num2str(dt) '_Ndt' num2str(N_dt) '_dtLims' num2str(-dt_lims(1)) '-' num2str(-dt_lims(2)) '.mat'];
filename = fullfile(pwd, data_path, filename);
if(~need_to_recomp && exist(filename, 'file'))
    load(filename, 'err_arr');
else
    err_arr = zeros(N_dt, 1);
    %parfor dt_i = 1:N_dt
    for dt_i = 1:N_dt
        disp(['dt_i proc: ' num2str(dt_i/N_dt)]);
        [h, u, v] = get_init_state(X, Y);    
        [~, ~, ~, err] = evol_sys_to_T(g, H, T, dt_arr(dt_i), h, u, v, X, Y, @th_solution, []);
        err_arr(dt_i) = err(end);
        if(draw_err)
            getFig('t', '$\langle r \rangle$', ['$err(r) | dt = 10^{' num2str(log(dt_arr(dt_i))/log(10)) '}$'], 'log', 'log');
            plot((1:length(err))*dt_arr(dt_i), err);
            legend off;
            pause(0.001);
        end
    end
    if(save_res)
        save(filename, 'err_arr');
    end
end

getFig('dt', 'err', ['T = ' num2str(T)], 'log', 'log');
plot(dt_arr, err_arr, 'o', 'LineWidth', 2);

