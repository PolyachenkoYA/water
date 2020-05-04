function [h_curr, u_curr, v_curr, err] = ...
    evol_sys_to_T_1(g, H, u_curr, v_curr, h_curr, Nt, dt, dx, dy,...
                  derivative_fun, step_fwd, prefix,...
                  figs, draw_evol, th_solution)
    draw_th = exist('th_solution', 'var');
    
    hmax = max(max(h_curr));
    [Ny, Nx] = size(h_curr);
    v0 = sqrt(g * H);
    [Xh, Yh] = meshgrid(((1:1:Nx) - 1/2) * dx, ((1:1:Ny) - 1/2) * dy);
    if(draw_th)
        h_th = th_solution(Xh, Yh, 0, v0);
    else
        h_th = [];
        ax_dh = [];        
    end    
    err = zeros(Nt, 1);
    
    if(draw_evol)
        [srf, v_fld, srf_dh, srf_th, vth_fld] = ...
            draw_surf(figs, Nx, dx, Ny, dy,...
                      u_curr, v_curr, h_curr, hmax, h_th);
        %input('press any key to start');
    end
        
    for i_t = 1:Nt
        [u_curr, v_curr, h_curr] = ...
            step_fwd(derivative_fun, g, H,...
                     u_curr, v_curr, h_curr, dx, dy, dt);

        if(draw_th)
            h_th = th_solution(Xh, Yh, i_t * dt, v0);
            err(i_t) = sqrt(sum(sum((h_curr - h_th).^2)) / (Nx * Ny));
        end

        if(mod(i_t, 1000) == 0)
            if(draw_evol)
                delete(srf);
                delete(srf_th);
                delete(v_fld);
                delete(vth_fld);
                delete(srf_dh);
                [srf, v_fld, srf_dh, srf_th, vth_fld] = ...
                    draw_surf(figs, Nx, dx, Ny, dy,...
                              u_curr, v_curr, h_curr, hmax, h_th);
                pause(0.001);
                %input('press any key');
            end    
            disp([prefix '; progress ' num2str(i_t / Nt)]);
        end        
    end
end