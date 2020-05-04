function draw_init(mesh, grid, state)
    getFig('x', 'y', 'grid');
    surf(grid.Xu, grid.Yu, ones(size(grid.Xu)));

    getFig('x', 'y', 'u(x,y)');
    surf(grid.Xu, mesh.y_fnc(grid.Xu, grid.Eta_u), state.u, 'EdgeColor', 'interp');
    getFig('x', 'y', 'h(x,y)');
    surf(grid.Xh, mesh.y_fnc(grid.Xh, grid.Eta_h), state.h, 'EdgeColor', 'interp');
    getFig('x', 'y', 'w(x,y)');
    surf(grid.Xw, mesh.y_fnc(grid.Xw, grid.Eta_w), state.w, 'EdgeColor', 'interp');
end