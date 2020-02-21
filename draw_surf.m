function srf = draw_surf(ax, X, Y, h)
    srf = surf(ax, X, Y, h, ...
        'EdgeColor', 'interp', 'FaceColor', 'interp');
    zlim([-1, 1]);
    caxis([-1, 1]);
end
