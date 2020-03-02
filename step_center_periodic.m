function [u, v, h] = step_center_periodic(g, H, u_prev, v_prev, h_prev, dx, dy, dt)
    du = zeros(size(u_prev));
    dv = zeros(size(v_prev));
    dh = zeros(size(h_prev));
    
    du(:, 2:(end - 1)) = -(g * dt * 2) * diff_center_walls(h_prev, [0, 1], dx);
    %du(:, 1) = 0; du(:, end) = 0;
    dv(2:(end - 1), :) = -(g * dt * 2) * diff_center_walls(h_prev, [1, 0], dy);
    %dv(1, :) = 0; dv(end, :) = 0;
    dh(:, 2:(end - 1)) = diff_center_walls(u_prev, [0, 1], dx);
    dh(2:(end - 1), :) = dh(2:(end - 1), :) + diff_center_walls(v_prev, [1, 0], dy);
    dh = -(H * dt * 2) * dh;
    
    du(:, 1) = -(g * dt * 2) * (h_prev(:, 2) - h_prev(:, end)) / (dx * 2);
    du(:, end) = -(g * dt * 2) * (h_prev(:, 1) - h_prev(:, end-1)) / (dx * 2);
    dv(1, :) = -(g * dt * 2) * (h_prev(2, :) - h_prev(end, :)) / (dy * 2);
    dv(end, :) = -(g * dt * 2) * (h_prev(1, :) - h_prev(end-1, :)) / (dy * 2);
    
    u = u_prev + du;
    v = v_prev + dv;
    h = h_prev + dh;
end