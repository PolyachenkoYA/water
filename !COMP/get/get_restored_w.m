function state = get_restored_w(mesh, grid, state)
    state.w(1, :) = mesh.w_lowerB_fnc(grid.Xw(1, :));
    state.w(end, :) = mesh.w_upperB_fnc(grid.Xw(end, :));
    state.u(:, end + 1) = state.u(:, 1);                                     % PBC
    u_forW = (state.u(1:(end-1), 1:(end-1)) + state.u(1:(end-1), 1:(end-1)) + ...
              state.u(2:(end), 1:(end-1)) + state.u(2:(end), 2:(end))) / 4;
    u_up = (state.u(1, :)*3 - state.u(2, :));  
    u_up = (u_up(1:end-1) + u_up(2:end)) / 2;
    u_down = (state.u(end, :)*3 - state.u(end-1, :));    
    u_down = (u_down(1:end-1) + u_down(2:end)) / 2;
    state.u(:, end) = [];                                                    % PBC
    state.w(2:(end-1), :) = (state.v(2:(end-1), :) - u_forW .* grid.sw(2:end-1,:)) ./ ...
                                sqrt(1 + grid.sw(2:end-1,:) .^2);
    state.wmax = max(state.w, [], 'all');
    state.maxV = sqrt(max([u_up; u_forW; u_down].^2 + state.v.^2, [], 'all'));
end