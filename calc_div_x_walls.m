function div_x = calc_div_x_walls(u,Nx,dx,Ny,dy)

div_x = zeros(Nx+1,Ny+1);

u(   1,:) = 0;
u(Nx+1,:) = 0;

ip = [3:Nx+1];
im = [1:Nx-1];

div_x(2:Nx,2:Ny) = (u(ip,2:Ny)-u(im,2:Ny))/(2*dx);

end

