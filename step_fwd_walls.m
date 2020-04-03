function [u_curr, v_curr, h_curr] = step_fwd_walls(g, H, u_curr, v_curr, h_curr, dx, dy, dt)
    [Ny, Nx] = size(h_curr);
    
    du = zeros(Ny, Nx + 1);
    du(:, 2:(end-1)) = -(g * dt/dx) * diff(h_curr, 1, 2);
    
    dv = zeros(Ny + 1, Nx);
    dv(2:(end-1), :) = -(g * dt/dy) * diff(h_curr, 1, 1); % Y points downwards
    
    dh = -(H * dt) * (diff(u_curr, 1, 2)/dx + diff(v_curr, 1, 1)/dy);
    
    u_curr = u_curr + du;
    v_curr = v_curr + dv;
    h_curr = h_curr + dh;        
%    u_curr(:, 1) = 0; u_curr(:, end) = 0;
%    v_curr(1, :) = 0; v_curr(end, :) = 0;    
end