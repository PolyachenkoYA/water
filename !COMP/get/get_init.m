function [mesh, fmt] = get_init
    mesh.H = 1;
    mesh.g = 1;
    mesh.v0 = sqrt(mesh.g * mesh.H);
    mesh.T_period = 2*pi / mesh.v0;
    mesh.Nx = 100;
    mesh.Ny = 100;
    mesh.dx = 2 * pi / mesh.Nx;
    mesh.dy = 2 * pi / mesh.Ny;
    mesh.dt = min(mesh.dx, mesh.dy) / mesh.v0 / 10;
    mesh.Nt = round(15 * mesh.T_period / mesh.dt) + 1;

    mesh.T = mesh.Nt * mesh.dt;
    mesh.Lx = mesh.dx * mesh.Nx;
    mesh.Ly = mesh.dy * mesh.Ny;
    mesh.de = 1 / mesh.Ny;

    fmt.to_draw_evol = 1;
    fmt.to_draw_err = 0;
    fmt.to_draw_inits = 0;
    mesh.x1 = mesh.Lx / 2;
    mesh.y1 = mesh.Ly / 3;
    mesh.sgm = mesh.Lx / 10;
    mesh.ys_fnc = @(x)get_ys(x, mesh.y1, mesh.x1, mesh.sgm, mesh.Lx);
    mesh.ys_derv_fnc = @(x)get_ys_derv(x, mesh.y1, mesh.x1, mesh.sgm, mesh.Lx);
    mesh.w_lowerB_fnc = @(x)get_w_lowerB(x);
    mesh.w_upperB_fnc = @(x)get_w_upperB(x);
    mesh.w_lowerBderv_fnc = @(x)get_w_lowerBderv(x);
    mesh.w_upperBderv_fnc = @(x)get_w_upperBderv(x);    
    mesh.y_fnc = @(x, eta)get_y(mesh.ys_fnc, x, eta, mesh.Ly);
    
    disp(['sgm = ' num2str(mesh.v0 * mesh.dt / mesh.dx)])
end