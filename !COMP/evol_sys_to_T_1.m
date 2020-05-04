function evol = evol_sys_to_T_1(mesh, grid, state_curr, fmt)
    if(fmt.to_draw_err)
        state_curr.h_th = mesh.th_solution(0);
    end    
    evol.err = zeros(mesh.Nt, 1);
    
    if(fmt.to_draw_evol)
        fmt.plots = draw_surf(grid, state_curr, fmt);
        input('press any key to start');
    end
        
    for i_t = 1:mesh.Nt
        state_curr = mesh.step_fwd(state_curr);

        if(fmt.to_draw_err)
            state_curr.h_th = mesh.th_solution(i_t * dt);
            evol.err(i_t) = sqrt(sum(sum((state_curr.h - state_curr.h_th).^2)) / (mesh.Nx * mesh.Ny));
        end

        if(mod(i_t, 10) == 0)
            if(fmt.to_draw_evol)
                fmt.plots = draw_surf(grid, state_curr, fmt);
                pause(0.001);
                input('press any key');
            end    
            disp([fmt.lbl '; progress ' num2str(i_t / mesh.Nt)]);
        end        
    end
end