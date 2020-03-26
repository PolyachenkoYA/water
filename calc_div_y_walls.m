function div_y = calc_div_y_walls(v,Nx,dx,Ny,dy)

div_y=zeros(Nx+1,Ny+1);

v(:,   1) = 0;
v(:,Ny+1) = 0;

ip = [3:Ny+1];
im = [1:Ny-1];

div_y(2:Nx,2:Ny) = (v(2:Nx,ip)-v(2:Ny,im))/(2*dy);

end