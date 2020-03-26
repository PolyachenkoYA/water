function [u_next, v_next, h_next] = step_center_walls(g, H, u_prev, v_prev, h_prev, u_curr, v_curr, h_curr, dx, dy, dt)
    du = -(g * dt * 2) * diff_center_periodic(h_curr, [0, 1], dx);
    du(:, 1) = 0; du(:, end) = 0;        
    dv = -(g * dt * 2) * diff_center_periodic(h_curr, [1, 0], dy);                      
    dv(1, :) = 0; dv(end, :) = 0;
    
    dhx = diff_center_periodic(u_curr, [0, 1], dx);
    dhx(:, 1) = 0; dhx(:, end) = 0;    
    dhy = diff_center_periodic(v_curr, [1, 0], dy);
    dhy(1, :) = 0; dhy(end, :) = 0;        
    dh = -(H * dt * 2) * (dhx + dhy); % wors OK    
    
    u_next = u_prev + du;
    v_next = v_prev + dv;
    h_next = h_prev + dh;   
    u_next(:, 1) = 0; u_next(:, end) = 0;
    v_next(1, :) = 0; u_next(end, :) = 0;        
end