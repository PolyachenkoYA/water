clear; close all;

H = 1;
g = 1;
l = 2*pi;
N = 50;
T = 50;
dt = 0.001;

Nt = T/dt;
dx = l/N;
dy = l/N;
%        (t     , y, x)
u = zeros(N, N, 2);
v = zeros(N, N, 2);
h = zeros(N, N, 2);
buf = zeros(N, N);
[Y, X] = meshgrid((1:N) * dy, (1:N) * dx);

u(:, :, 2) = 0;
v(:, :, 2) = 0;
h(:, :, 2) = exp(-(((X - 1) / 1).^2 + ((Y - 2) / 1).^2)) .* (Y - dy) .* (X - dx) .* (l - Y) .* (l - X);
h(:, :, 2) = h(:, :, 2) / max(max(h(:, :, 2)));

u(:, :, 1) = u(:, :, 2) + g * dt/dx * (circshift(h(:, :, 2), [0, 0, 1]) - h(:, :, 2));
v(:, :, 1) = v(:, :, 2) + g * dt/dy * (circshift(h(:, :, 2), [0, -1, 0]) - h(:, :, 2));
h(:, :, 1) = h(:, :, 2) + H * ((circshift(u(:, :, 2), [0, 0, 1]) - u(:, :, 2)) * dt/dx + ...
                               (circshift(v(:, :, 2), [0, -1, 0]) - v(:, :, 2)) * dt/dy);
getFig('x', 'y', 'h(x,y)', '', '', '', 'h');
legend off;
hold off;
view(-37.5, 30);
for it = 2:Nt
    buf = u(:, :, 1) - g * dt/dx * (circshift(h(:, :, 2), [0, 0, 1]) - circshift(h(:, :, 2), [0, 0, -1]));
    u(:, :, 1) = u(:, :, 2);
    u(:, :, 2) = buf; 
    
    buf = v(:, :, 1) - g * dt/dy * (circshift(h(:, :, 2), [0, -1, 0]) - circshift(h(:, :, 2), [0, 1, 0]));
    v(:, :, 1) = v(:, :, 2);
    v(:, :, 2) = buf;
    
    buf = h(:, :, 1) - H * ((circshift(u(:, :, 2), [0, 0, 1]) - circshift(u(:, :, 2), [0, 0, -1])) * dt/dx + ...
                            (circshift(v(:, :, 2), [0, -1, 0]) - circshift(v(:, :, 2), [0, 1, 0])) * dt/dy);
    h(:, :, 1) = h(:, :, 2);
    h(:, :, 2) = buf;
    
    if(mod(it, 10) == 0)
        surf(X, Y, squeeze(h(:, :, 2)), ...
            'EdgeColor', 'interp', 'FaceColor', 'interp', 'HandleVisibility', 'off');
        zlim([-1, 1]);
        pause(0.01);
    end    
    disp(it / Nt);
end

