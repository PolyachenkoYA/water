function grad_y = calc_grad_y_walls(h,Nx,dx,Ny,dy)

grad_y=zeros(Nx+1,Ny+1);

h(:,   1) = h(:,2 );
h(:,Ny+1) = h(:,Ny);

ip = [3:Ny+1];
im = [1:Ny-1];

grad_y(2:Nx,2:Ny) = (h(2:Nx,ip)-h(2:Ny,im))/(2*dy);

end