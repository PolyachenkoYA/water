function [u, v, h] = step_fwd_periodic(g, H, u_prev, v_prev, h_prev, dx, dy, dt)
    N = size(h_prev, 1);
    du = -(g * dt) * diff_center_periodic(h_prev, [0, 1], dx);
    dv = -(g * dt) * diff_center_periodic(h_prev, [1, 0], dy);
    dh = -(H * dt) * (diff_center_periodic(u_prev, [0, 1], dx) + ...
                      diff_center_periodic(v_prev, [1, 0], dy)); % wors OK
    
    du(:, 1) = -(g * dt) * (h_prev(:, 2) - h_prev(:, 1)) / (dx);
    du(:, N) = -(g * dt) * (h_prev(:, 1) - h_prev(:, N)) / (dx);
    dv(1, :) = -(g * dt) * (h_prev(2, :) - h_prev(1, :)) / (dy);
    dv(N, :) = -(g * dt) * (h_prev(1, :) - h_prev(N, :)) / (dy);
    
    u = u_prev + du;
    v = v_prev + dv;
    h = h_prev + dh;    
end