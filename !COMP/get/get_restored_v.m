function state = get_restored_v(grid, state)
    state.u(:, end+1) = state.u(:, 1);
    u_forV = (state.u(1:end-1, 1:end-1) + state.u(1:end-1, 2:end) + ...
                 state.u(2:end, 1:end-1) + state.u(2:end, 2:end)) / 4;
    u_up = (state.u(1, :)*3 - state.u(2, :));  
    u_up = (u_up(1:end-1) + u_up(2:end)) / 2;
    u_down = (state.u(end, :)*3 - state.u(end-1, :));    
    u_down = (u_down(1:end-1) + u_down(2:end)) / 2;
    state.v(2:end-1, :) = state.w(2:end-1, :) .* sqrt(1 + grid.sw(2:end-1, :).^2) + ...
                          u_forV .* grid.sw(2:end-1, :);
    state.v(1, :) = state.w(1, :) .* sqrt(1 + grid.sw(1, :).^2) + ...
                    u_up .* grid.sw(1, :);
    state.v(end, :) = state.w(end, :) .* sqrt(1 + grid.sw(end, :).^2) + ...
                    u_down .* grid.sw(end, :);
    state.u(:, end) = [];
    state.maxV = sqrt(max([u_up; u_forV; u_down].^2 + state.v.^2, [], 'all'));
end