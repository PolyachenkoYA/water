function [h, u, v, err] = evol_sys_to_T_2(g, H, T, dt, h, u, v, X, Y, step_fwd, step_center, th_solution, sol_ax, prefix)
    if(exist('sol_ax', 'var'))
        draw_evol = ~isempty(sol_ax);
    else
        draw_evol = 0;
    end
    draw_th = 0;
    
    hmax = max(max(h));
    dx = abs(X(1,1) - X(2,1));
    dy = abs(Y(1,1) - Y(1,2));
    Nt = round(T/dt);
    v0 = sqrt(g * H);
    N = size(X, 1);

    err = zeros(Nt, 1);
    u_prev = u;
    v_prev = v;
    h_prev = h;
    [u, v, h] = step_fwd(g, H, u_prev, v_prev, h_prev, dx, dy, dt);
    h_th = th_solution(X, Y, 1 * dt * v0);
    err(1) = sum(sum((h - h_th).^2)) / N^2;
    
    if(draw_evol)
        srf = surf(sol_ax, X, Y, h,...
            'EdgeColor', 'interp', 'FaceColor', 'interp', 'DisplayName', 'numerical');
        if(draw_th)
            srf_th = surf(sol_ax, X, Y, h_th, ...
                'EdgeColor', 'interp', 'FaceColor', 'interp', 'DisplayName', 'theory',...
                'FaceAlpha', 0.5, 'EdgeAlpha', 0.5);
        end
        zlim([-hmax, hmax]);
        caxis([-hmax, hmax]);  
        input('press any key to start');
    end

    for i_t = 2:Nt
        [u_prev, v_prev, h_prev] = ...
            step_center(g, H, u_prev, v_prev, h_prev, u, v, h, dx, dy, dt);

        % this might be inefficient because swap will allocate NxN array every
        % time
        [u, u_prev] = deal(u_prev, u);
        [v, v_prev] = deal(v_prev, v);
        [h, h_prev] = deal(h_prev, h);

        h_th = th_solution(X, Y, i_t * dt * v0);
        err(i_t) = sum(sum((h - h_th).^2)) / N^2;

        if(mod(i_t, 1000) == 0)
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