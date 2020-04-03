function [srf, srf_th] = draw_surf(ax, Xh, Yh, h, zbounds, h_th)
    zbounds = [-zbounds, zbounds];
    srf = surf(ax, Xh, Yh, h, ...
               'EdgeColor', 'interp', 'FaceColor', 'interp');
    if(isempty(h_th))
        srf_th = [];
    else
        srf_th = surf(ax, Xh, Yh, h_th, 'DisplayName', 'theory',...
            'EdgeColor', 'interp', 'FaceColor', 'interp', ...
            'FaceAlpha', 0.5, 'EdgeAlpha', 0.5);        
    end
    zlim(zbounds);
    caxis(zbounds);
end
