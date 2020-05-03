function [u_prev, v_prev, h_prev] = ...
    step_center(derivative_fun, g, H, u_prev,...
                      v_prev, h_prev, u_curr, v_curr, h_curr, dx, dy, dt)
                  
    [dh, du, dv] = derivative_fun(g, H, h_curr, u_curr, v_curr, dx, dy);
    
    h_prev = h_prev + dh * (2 * dt);
    u_prev = u_prev + du * (2 * dt);
    v_prev = v_prev + dv * (2 * dt);
end