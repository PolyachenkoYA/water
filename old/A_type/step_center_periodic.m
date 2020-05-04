function [u, v, h] = step_center_periodic(g, H, u_prev, v_prev, h_prev, u_curr, v_curr, h_curr, dx, dy, dt)
    N = size(h_prev, 1);
    du = -(g * dt * 2) * diff_center_periodic(h_curr, [0, 1], dx);
    dv = -(g * dt * 2) * diff_center_periodic(h_curr, [1, 0], dy);
    dh = -(H * dt * 2) * (diff_center_periodic(u_curr, [0, 1], dx) + ...
                          diff_center_periodic(v_curr, [1, 0], dy)); % wors OK
    
    du(:, 1) = -(g * dt * 2) * (h_curr(:, 2) - h_curr(:    , N    )) / (dx * 2);
    du(:, N) = -(g * dt * 2) * (h_curr(:, 1) - h_curr(:    , N - 1)) / (dx * 2);
    dv(1, :) = -(g * dt * 2) * (h_curr(2, :) - h_curr(N    , :    )) / (dy * 2);
    dv(N, :) = -(g * dt * 2) * (h_curr(1, :) - h_curr(N - 1, :    )) / (dy * 2);    
    
    u = u_prev + du;
    v = v_prev + dv;
    h = h_prev + dh;
end