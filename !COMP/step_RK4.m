function s_curr = step_RK4(mesh, grid, s_curr)
    st_1 = mesh.derivative_fun(s_curr);
    st_2 = mesh.derivative_fun(state_add(s_curr, state_mult(st_1, mesh.dt / 2)));
    st_3 = mesh.derivative_fun(state_add(s_curr, state_mult(st_2, mesh.dt / 2)));
    st_4 = mesh.derivative_fun(state_add(s_curr, state_mult(st_3, mesh.dt)));
    
    s_curr.h = s_curr.h + (st_1.h + st_2.h * 2 + st_3.h * 2 + st_4.h) * (mesh.dt / 6);
    s_curr.u = s_curr.u + (st_1.u + st_2.u * 2 + st_3.u * 2 + st_4.u) * (mesh.dt / 6);
    s_curr.w = s_curr.w + (st_1.w + st_2.w * 2 + st_3.w * 2 + st_4.w) * (mesh.dt / 6);    
    s_curr.w(1, :) = mesh.w_lowerB_fnc(grid.Xw(1, :));
    s_curr.w(end, :) = mesh.w_upperB_fnc(grid.Xw(end, :));
    
    % reconstruct v from w and u
    s_curr.u(:, end+1) = s_curr.u(:, 1);
    s_curr.v(2:end-1, :) = s_curr.w(2:end-1, :) .* sqrt(1 + grid.sw(2:end-1, :).^2) + ...
               ((s_curr.u(1:end-1, 1:end-1) + s_curr.u(1:end-1, 2:end) + ...
                 s_curr.u(2:end, 1:end-1) + s_curr.u(2:end, 2:end)) / 4) .* grid.sw(2:end-1, :);
    d = (s_curr.u(1, :)*3 - s_curr.u(2, :));
    s_curr.v(1, :) = (d(1:end-1) + d(2:end)) / 2;
    d = (s_curr.u(end, :)*3 - s_curr.u(end-1, :));
    s_curr.v(end, :) = (d(1:end-1) + d(2:end)) / 2;
    s_curr.u(:, end) = [];
end