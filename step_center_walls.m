function [u, v, h] = step_center_walls(g, H, u_prev, v_prev, h_prev, dx, dy, dt)
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
        
    u = u_prev + du;
    v = v_prev + dv;
    h = h_prev + dh;
    
    u(:, 1) = 0; u(:, end) = 0;
    v(1, :) = 0; v(end, :) = 0;    
end