clear;
close all;

%% ============== init params =============
[mesh, fmt] = get_init;

%% =============== init state ================
[mesh, grid, state] = get_init_state(mesh, 1);
if(fmt.to_draw_inits)
    draw_inits(mesh, grid, state);
end

fmt = get_init_fmt(mesh, fmt);

%% =============== evolve =================
evol = evol_sys_to_T_1(mesh, grid, state, fmt);

if(any(evol.err ~= 0))
    fmt.figs.fig_err_t = getFig('t', '$\sqrt{< r^2 >_{x}}$', 'err(t)', 'log', 'log');
    plot(fmt.figs.fig_err_t.ax, (1:mesh.Nt) * mesh.dt, evol.err, 'DisplayName', 'error');
    plot(fmt.figs.fig_err_t.ax, [1, 1] * mesh.T_period, [1e-5, max(evol.err) / 2], 'DisplayName', 'period');
end
