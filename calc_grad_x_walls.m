function grad_x = calc_grad_x_walls(h,Nx,dx,Ny,dy)

grad_x = zeros(Nx+1,Ny+1);

h(   1,:) = h( 2,:);
h(Nx+1,:) = h(Nx,:);

ip = [3:Nx+1];
im = [1:Nx-1];

grad_x(2:Nx,2:Ny) = (h(ip,2:Ny)-h(im,2:Ny))/(2*dx);

end

