function [h_curr, u_curr, v_curr, err] = ...
    evol_sys_to_T_2(g, H, u_prev, v_prev, h_prev, Nt, dt, dx, dy,...
                  step_fwd, step_center, prefix, ax_h, ax_v, ax_dh, th_solution)
    if(exist('ax_h', 'var'))
        draw_evol = ~isempty(ax_h);
    else
        draw_evol = 0;
    end
    draw_th = exist('th_solution', 'var');
    
    hmax = max(max(h_prev));
    [Ny, Nx] = size(h_prev);
    v0 = sqrt(g * H);
    [Xh, Yh] = meshgrid(((1:1:Nx) - 1/2) * dx, ((1:1:Ny) - 1/2) * dy);
    err = zeros(Nt, 1);    
    
    [u_curr, v_curr, h_curr] = step_fwd(g, H, u_prev, v_prev, h_prev, dx, dy, dt);
    if(draw_th)
        h_th = th_solution(Xh, Yh, 1 * dt, v0);
        err(1) = sqrt(sum(sum((h_curr - h_th).^2)) / (Nx * Ny));
    else
        h_th = [];
        ax_dh = [];
    end    
    
    if(draw_evol)
        [srf, v_fld, srf_dh, srf_th, vth_fld] = draw_surf(ax_h, ax_v, ax_dh, Nx, dx, Ny, dy,...
                                         u_curr, v_curr, h_curr, hmax, h_th);
        input('press any key to start');
    end
        
    for i_t = 2:Nt
        [u_prev, v_prev, h_prev] = step_center(g, H, u_prev, v_prev, h_prev, u_curr, v_curr, h_curr, dx, dy, dt);
        
        [u_curr, v_curr, h_curr, u_prev, v_prev, h_prev] = deal(u_prev, v_prev, h_prev, u_curr, v_curr, h_curr);

        if(draw_th)
            h_th = th_solution(Xh, Yh, i_t * dt, v0);
            err(i_t) = sqrt(sum(sum((h_curr - h_th).^2)) / (Nx * Ny));
        end

        if(mod(i_t, 10) == 0)
            if(draw_evol)
                delete(srf);
                delete(srf_th);
                delete(v_fld);
                delete(vth_fld);
                delete(srf_dh);
                [srf, v_fld, srf_dh, srf_th, vth_fld] = ...
                    draw_surf(ax_h, ax_v, ax_dh, Nx, dx, Ny, dy,...
                              u_curr, v_curr, h_curr, hmax, h_th);
                pause(0.001);
                %input('press any key');
            end    
            disp([prefix '; progress ' num2str(i_t / Nt)]);
        end        
    end
end