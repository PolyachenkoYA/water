function fmt = get_init_fmt(mesh, fmt)
    fmt.figs = getInitFigs(fmt);
    fmt.lbl = ['dt = ' num2str(mesh.dt) '; dx = ' num2str(mesh.dx)];
    fmt.plots.srf = [];
    fmt.plots.srf_th = [];
    fmt.plots.v_fld = [];
    fmt.plots.vth_fld = [];
    fmt.plots.srf_dh = [];
end