function srf = draw_surf(ax, X, Y, h, zbounds)
    zbounds = [-zbounds, zbounds];
    srf = surf(ax, X, Y, h, ...
        'EdgeColor', 'interp', 'FaceColor', 'interp');
    zlim(zbounds);
    caxis(zbounds);
end
