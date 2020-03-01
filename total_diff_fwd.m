function [u, v, h] = total_diff_fwd(diff_fwd, g, H, u_prev, v_prev, h_prev, dx, dy, dt)
    u = u_prev - (g * dt) * diff_fwd(h_prev, [0, 1], dx);
    v = v_prev - (g * dt) * diff_fwd(h_prev, [1, 0], dy);
    h = h_prev - (H * dt) * (diff_fwd(u_prev, [0, 1], dx) + diff_fwd(v_prev, [1, 0], dy));
end