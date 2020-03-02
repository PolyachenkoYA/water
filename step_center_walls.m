function [u, v, h] = step_center_walls(g, H, u_prev, v_prev, h_prev, dx, dy, dt)
    N = size(h_prev, 1);
    du = -(g * dt * 2) * diff_center_periodic(h_prev, [0, 1], dx);
    dv = -(g * dt * 2) * diff_center_periodic(h_prev, [1, 0], dy);
    dh = -(H * dt * 2) * (diff_center_periodic(u_prev, [0, 1], dx) + ...
                          diff_center_periodic(v_prev, [1, 0], dy)); % wors OK
    
    du(:, 1) = -(g * dt * 2) * (h_prev(:, 2) - h_prev(:    , N    )) / (dx * 2);
    du(:, N) = -(g * dt * 2) * (h_prev(:, 1) - h_prev(:    , N - 1)) / (dx * 2);
    dv(1, :) = -(g * dt * 2) * (h_prev(2, :) - h_prev(N    , :    )) / (dy * 2);
    dv(N, :) = -(g * dt * 2) * (h_prev(1, :) - h_prev(N - 1, :    )) / (dy * 2);    
    
    u = u_prev + du;
    v = v_prev + dv;
    h = h_prev + dh;
    
    u(:, 1) = 0; u(:, end) = 0;
    v(1, :) = 0; v(end, :) = 0;    
end