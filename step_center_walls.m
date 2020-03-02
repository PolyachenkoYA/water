function [u, v, h] = step_center_walls(g, H, u_prev, v_prev, h_prev, dx, dy, dt)
    N = size(h_prev, 1);
    du = -(g * dt * 2) * diff_center_periodic(h_prev, [0, 1], dx);
    dv = -(g * dt * 2) * diff_center_periodic(h_prev, [1, 0], dy);
    dh = -(H * dt * 2) * (diff_center_periodic(u_prev, [0, 1], dx) + ...
                          diff_center_periodic(v_prev, [1, 0], dy)); % wors OK
        
    u = u_prev + du;
    v = v_prev + dv;
    h = h_prev + dh;
    
    u(:, 1) = 0; u(:, N) = 0;
    v(1, :) = 0; v(N, :) = 0;    
end