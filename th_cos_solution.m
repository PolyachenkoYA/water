function f = th_cos_solution(X, Y, t, v0)
    [Ny, Nx] = size(X);
    lx = (X(1,2) - X(1,1)) * Nx;
    ly = (Y(2,1) - Y(1,1)) * Ny;
    f = cos(X * (2*pi / lx)) * cos(t * (2*pi*v0 / lx)) + cos(Y * 2 * (2*pi / ly)) * cos(t * 2 * (2*pi*v0 / ly));
end