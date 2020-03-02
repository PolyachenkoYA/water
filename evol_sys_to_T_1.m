function [h, u, v, err] = evol_sys_to_T_1(g, H, T, dt, h, u, v, X, Y, diff_fwd, th_solution, sol_ax, prefix)
    if(exist('sol_ax', 'var'))
        draw_evol = ~isempty(sol_ax);
    else
        draw_evol = 0;
    end
    draw_th = 1;
    
    hmax = max(max(h));
    dx = abs(X(1,1) - X(2,2));
    dy = abs(Y(1,1) - Y(2,2));
    Nt = round(T/dt);
    v0 = sqrt(g * H);
    N = size(X, 1);
        
    if(draw_evol)
        srf = surf(sol_ax, X, Y, h,...
            'EdgeColor', 'interp', 'FaceColor', 'interp', 'DisplayName', 'numerical');
        if(draw_th)
            h_th = th_solution(X, Y, 0);
            srf_th = surf(sol_ax, X, Y, h_th, ...
                'EdgeColor', 'interp', 'FaceColor', 'interp', 'DisplayName', 'theory',...
                'FaceAlpha', 0.5, 'EdgeAlpha', 0.5);
        end
        zlim([-hmax, hmax]);
        caxis([-hmax, hmax]);  
        input('press any key to start');
    end

    err = zeros(Nt, 1);    
    for i_t = 1:Nt
        [u, v, h] = ...
            total_diff_fwd(diff_fwd, ...
            g, H, u, v, h, dx, dy, dt);
        
        h_th = th_solution(X, Y, i_t * dt * v0);
        err(i_t) = sum(sum((h - h_th).^2)) / N^2;

        if(mod(i_t, 100) == 0)
            if(draw_evol)
                delete(srf);
                if(draw_th)
                    delete(srf_th);
                    srf_th = surf(sol_ax, X, Y, h_th, ...
                        'EdgeColor', 'interp', 'FaceColor', 'interp', 'DisplayName', 'theory',...
                        'FaceAlpha', 0.5, 'EdgeAlpha', 0.5);
                end
                srf = surf(sol_ax, X, Y, h,...
                    'EdgeColor', 'interp', 'FaceColor', 'interp', 'DisplayName', 'numerical');
                zlim([-hmax, hmax]);
                caxis([-hmax, hmax]);
                pause(0.001);
            end    
            disp([prefix '; progeess ' num2str(i_t / Nt)]);
        end        
    end
end