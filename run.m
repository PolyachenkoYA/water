clear; close all;

H = 1;
g = 1;
l = 2*pi;
N = 100;
T = 50;
dt = 0.001;

Nt = T/dt;
dx = l/N;
dy = l/N;
%        (t     , y, x)
u = zeros(N, N);
v = zeros(N, N);
%h = zeros(N, N);
%u_prev = zeros(N, N);
%v_prev = zeros(N, N);
%h_prev = zeros(N, N);
buf = zeros(N, N);
[Y, X] = meshgrid((1:N) * dy, (1:N) * dx);

u(:) = 0;
v(:) = exp(-(((X - 2) / 2).^2 + ((Y - 2) / 1).^2)) .* (Y - dy) .* (X - dx) .* (l - Y) .* (l - X);
h = exp(-(((X - 1) / 2).^2 + ((Y - 2) / 1).^2)) .* (Y - dy) .* (X - dx) .* (l - Y) .* (l - X);
h = h / max(max(h));
v = v / max(max(v)) * 2;

u_prev = u + (g * dt) * diff_fwd(h, [0, 1], dx);
v_prev = v + (g * dt) * diff_fwd(h, [-1, 0], dy);
h_prev = h + (H * dt) * (diff_fwd(u, [0, 1], dx) + diff_fwd(v, [-1, 0], dy));

[fig, ax, leg] = getFig('x', 'y', 'h(x,y)', '', '', '', 'h');
legend(ax, 'off');
view(-37.5, 30);
srf = draw_surf(ax, X, Y, h);
for i_t = 2:Nt
    u_prev = u_prev - (g * dt) * diff_center(h, [0, 1], dx);
    v_prev = v_prev - (g * dt) * diff_center(h, [-1, 0], dy);
    h_prev = h_prev - (H * dt) * (diff_center(u, [0, 1], dx) + diff_center(v, [-1, 0], dy));
    
    % this might be inefficient because swap will allocate NxN array every
    % time
    [u_prev, u] = swap(u_prev, u);
    [v_prev, v] = swap(v_prev, v);
    [h_prev, h] = swap(h_prev, h);
    
    if(mod(i_t, 10) == 0)
        delete(srf);
        srf = draw_surf(ax, X, Y, h);
        pause(0.001);
    end    
    disp(i_t / Nt);
end

