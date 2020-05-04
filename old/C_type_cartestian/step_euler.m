function [u_curr, v_curr, h_curr] = ...
             step_euler(derivative_fun, g, H,...
                        u_curr, v_curr, h_curr, dx, dy, dt)
    [dh, du, dv] = derivative_fun(g, H, h_curr, u_curr, v_curr, dx, dy);
    
    h_curr = h_curr + dh * dt;
    u_curr = u_curr + du * dt;
    v_curr = v_curr + dv * dt;
end