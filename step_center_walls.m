function [u_prev, v_prev, h_prev] = step_center_walls(g, H, u_prev, v_prev, h_prev, u_curr, v_curr, h_curr, dx, dy, dt)
    [Ny, Nx] = size(h_curr);
    
    du = zeros(Ny, Nx + 1);
    du(:, 2:(end-1)) = -(g * 2 * dt / dx) * diff(h_curr, 1, 2);
    
    dv = zeros(Ny + 1, Nx);
    dv(2:(end-1), :) = -(g * 2 * dt / dy) * diff(h_curr, 1, 1); % Y points downwards
    
    dh = -(H * 2 * dt) * (diff(u_curr, 1, 2) / dx + diff(v_curr, 1, 1) / dy);
    
    u_prev = u_prev + du;
    v_prev = v_prev + dv;
    h_prev = h_prev + dh;        
end