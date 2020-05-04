function f = th_cos_solution(mesh, X, Y, t)
    f = cos(X * (2*pi / mesh.Lx)) * cos(t * (2*pi*mesh.v0 / mesh.Lx)) + ...
        cos(Y * 2 * (2*pi / mesh.Ly)) * cos(t * 2 * (2*pi*mesh.v0 / mesh.Ly));
end