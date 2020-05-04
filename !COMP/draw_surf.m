function plots = draw_surf(mesh, grid, state, fmt)
    delete(fmt.plots.srf);
    delete(fmt.plots.srf_th);
    delete(fmt.plots.v_fld);
    delete(fmt.plots.vth_fld);
    delete(fmt.plots.srf_dh);

    fmt.zbounds = [-1, 1] * state.hmax;
    plots.srf = surf(fmt.figs.fig_h.ax, grid.Xh, grid.Yh, state.h, ...
               'EdgeColor', 'interp', 'FaceColor', 'interp');
    if(fmt.to_draw_err)
        plots.srf_th = surf(fmt.figs.fig_h.ax, grid.Xh, grid.Yh, state.h_th, 'DisplayName', 'theory',...
            'EdgeColor', 'interp', 'FaceColor', 'interp', ...
            'FaceAlpha', 0.5, 'EdgeAlpha', 0.5);        
        
        plots.srf_dh = surf(fmt.figs.fig_dh.ax, grid.Xh, grid.Yh, abs(state.h - state.h_th),...
            'EdgeColor', 'interp', 'FaceColor', 'interp');                
        
        plots.vth_fld = [];
        %plots.vth_fld = quiver(fmt.fig_v.ax, Xh, Yh, ...
        %               (u(:, 1:(end-1)) + u(:, 2:end))/2,...
        %               (v(1:(end-1), :) + v(2:end, :))/2,...
        %               'Color', getMyColor(2));                
    else
        plots.srf_th = [];
        plots.srf_dh = [];
        plots.vth_fld = [];        
    end
    zlim(fmt.figs.fig_h.ax, fmt.zbounds);
    caxis(fmt.figs.fig_h.ax, fmt.zbounds);
    
    state.u(:, end+1) = state.u(:, 1);
    plots.v_fld = quiver(fmt.figs.fig_v.ax, grid.Xh, grid.Yh, ...
                   (state.u(:, 1:(end-1)) + state.u(:, 2:end)) / 2 / mesh.maxVinit / mesh.Lx,...
                   (state.v(1:(end-1), :) + state.v(2:end, :)) / 2 / mesh.maxVinit / mesh.Ly,...
                   'Color', getMyColor(2),'AutoScale','off');
    xlim(fmt.figs.fig_v.ax, [0, mesh.Lx]);
    ylim(fmt.figs.fig_v.ax, [0, mesh.Ly]);
    state.u(:, end) = [];
end
