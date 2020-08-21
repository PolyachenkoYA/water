clear all;
close all;

Lx = 2*pi;
Ly = 2*pi;

Nx = 64;
Ny = 64;

dx = Lx/Nx;
dy = Ly/Ny;

x = [0:Nx]'*dx;
y = [0:Ny]'*dy;

[X,Y]=meshgrid(x,y);

h = zeros(Nx+1,Ny+1);
u = h; v = h;


dt = dx/2;

h = exp(-(X-Lx/2).^2).*exp(-(Y-Ly/2).^2);

up = u;
vp = v;
hp = h;

u = u - dt*calc_grad_x_walls(h,Nx,dx,Ny,dy); 
v = v - dt*calc_grad_y_walls(h,Nx,dx,Ny,dy);  
h = h - dt*(calc_div_x_walls(u,Nx,dx,Ny,dy) + calc_div_y_walls(v,Nx,dx,Ny,dy));

for t = 1:1000
   
   
   un = up - dt*calc_grad_x_walls(h,Nx,dx,Ny,dy); 
   vn = vp - dt*calc_grad_y_walls(h,Nx,dx,Ny,dy);  
   hn = hp - dt*(calc_div_x_walls(u,Nx,dx,Ny,dy) + calc_div_y_walls(v,Nx,dx,Ny,dy));
   
   up = u;
   vp = v;
   hp = h;
   
   u = un;
   v = vn;
   h = hn;
   
   surf(hn(2:Nx,2:Ny))
   pause(0.01)
end



