function [h, u, v] = get_init_state(Nx, dx, Ny, dy, mode)    
    u = zeros(Ny, Nx + 1);
    v = zeros(Ny + 1, Nx);
    lx = Nx * dx;
    ly = Ny * dy;

    [Xu, Yu] = meshgrid((0:1:Nx) * dx, ((1:1:Ny) - 1/2) * dy);
    [Xv, Yv] = meshgrid(((1:1:Nx) - 1/2) * dx, (0:1:Ny) * dy);
    [Xh, Yh] = meshgrid(((1:1:Nx) - 1/2) * dx, ((1:1:Ny) - 1/2) * dy);
    
    switch(mode)
        case 1            
            u = exp(-(((Xu - 2) / 2).^2 + ((Yu - 2) / 1).^2)) .* ...
                (Yu - dy/2) .* (Xu) .* (ly - dy/2 - Yu) .* (lx - Xu);
            v = exp(-(((Xv - 2) / 2).^2 + ((Yv - 2) / 1).^2)) .* ...
                (Yv) .* (Xv - dx/2) .* (ly - Yv) .* (lx - dx/2 - Xv);            
            h = exp(-(((Xh - 1) / 2).^2 + ((Yh - 2) / 1).^2)) .* ...
                (Yh - dy/2) .* (Xh - dx/2) .* (ly - dy/2 - Yh) .* (lx - dx/2 - Xh);
            
            h = h / max(max(h));
            v = v / max(max(v)) / 2;
            u = u / max(max(v)) / 3;
        case 2
            h = cos(Xh * (2*pi / lx)) + cos(Yh * 2 * (2*pi / ly)); % h(t,x,y) = cos(x) * cos(t * v0) + cos(2y) * cos(2t * v0);
    end

end