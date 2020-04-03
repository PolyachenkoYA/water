function [h, u, v, err] = evol_sys_to_T(g, H, u, v, h, Nt, dt, dx, dy,...
                                        step_fwd, prefix, sol_ax, th_solution)
    if(exist('sol_ax', 'var'))
        draw_evol = ~isempty(sol_ax);
    else
        draw_evol = 0;
    end
    draw_th = exist('th_solution', 'var');
    
    hmax = max(max(h));
    [Ny, Nx] = size(h);
    v0 = sqrt(g * H);
    [Xh, Yh] = meshgrid(((1:1:Nx) - 1/2) * dx, ((1:1:Ny) - 1/2) * dy);
    if(draw_th)
        h_th = th_solution(Xh, Yh, 0);
    else
        h_th = [];
    end    
    err = zeros(Nt, 1);
    
    if(draw_evol)
        [srf, srf_th] = draw_surf(sol_ax, Xh, Yh, h, hmax, h_th);
        input('press any key to start');
    end
    
    for i_t = 1:Nt
        [u, v, h] = step_fwd(g, H, u, v, h, dx, dy, dt);

        if(draw_th)
            h_th = th_solution(Xh, Yh, i_t * dt * v0);
            err(i_t) = sum(sum((h - h_th).^2)) / (Nx * Ny);
        end

        if(mod(i_t, 1000) == 0)
            if(draw_evol)
                delete(srf);
                delete(srf_th);
                [srf, srf_th] = draw_surf(sol_ax, Xh, Yh, h, hmax, h_th);
                pause(0.001);
            end    
            disp([prefix '; progress ' num2str(i_t / Nt)]);
        end        
    end
end