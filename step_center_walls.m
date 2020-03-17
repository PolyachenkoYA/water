function [u, v, h] = step_center_walls(g, H, u_prev, v_prev, h_prev, dx, dy, dt)
    du = -(g * dt * 2) * diff_center_periodic(h_prev, [0, 1], dx);
    dv = -(g * dt * 2) * diff_center_periodic(h_prev, [1, 0], dy);
    dh = -(H * dt * 2) * (diff_center_periodic(u_prev, [0, 1], dx) + ...
                          diff_center_periodic(v_prev, [1, 0], dy)); % wors OK
                      
    dh(1, :) = 0; dh(end, :) = 0;
    dh(:, 1) = 0; dh(:, end) = 0;
    u = u_prev + du;
    v = v_prev + dv;
    h = h_prev + dh;
    
    u(:, 1) = 0; u(:, end) = 0;
    v(1, :) = 0; v(end, :) = 0;    
end