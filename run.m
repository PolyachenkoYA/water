clear; close all;

%% ================ initial params =================
H = 1;
g = 1;
l = 2*pi;
N = 100;
T = 50;
dt = 0.01;

draw_err = 1;
draw_evol = 0;
%need_to_recomp = 1;

Nt = T/dt;
dx = l/N;
dy = l/N;
v0 = sqrt(g * H);
[Y, X] = meshgrid((1:N) * dy, (1:N) * dx);

%% ================ initial state =================
%u(:) = 0;
%v(:) = exp(-(((X - 2) / 2).^2 + ((Y - 2) / 1).^2)) .* (Y - dy) .* (X - dx) .* (l - Y) .* (l - X);
%h = exp(-(((X - 1) / 2).^2 + ((Y - 2) / 1).^2)) .* (Y - dy) .* (X - dx) .* (l - Y) .* (l - X);
%h = h_prev / max(max(h_prev));
%v = v_prev / max(max(v_prev)) * 0.5;

h = cos(X) + cos(Y); % h(t,x,y) = cos(t)*(cos(x) + cos(y));
u(:) = 0;
v(:) = 0;
hmax = max(max(h));

%% ================== comp & visz =====================
r = zeros(Nt, 1);
u_prev = u;
v_prev = v;
h_prev = h;
u = u_prev - (g * dt) * diff_fwd(h_prev, [0, 1], dx);
v = v_prev - (g * dt) * diff_fwd(h_prev, [-1, 0], dy);
h = h_prev - (H * dt) * (diff_fwd(u_prev, [0, 1], dx) + diff_fwd(v_prev, [-1, 0], dy));
h_th = cos(1 * dt * v0) * (cos(X) + cos(Y));
r(1) = sum(sum((h - h_th).^2)) / N^2;

if(draw_evol)
    [fig, ax, leg] = getFig('x', 'y', 'h(x,y)', '', '', '', 'h');
    view(-37.5, 30);
    srf = surf(ax, X, Y, h,...
        'EdgeColor', 'interp', 'FaceColor', 'interp', 'DisplayName', 'numerical');
    srf_th = surf(ax, X, Y, cos(1 * dt * v0) * (cos(X) + cos(Y)), ...
        'EdgeColor', 'interp', 'FaceColor', 'interp', 'DisplayName', 'theory');
    zlim([-hmax, hmax]);
    caxis([-hmax, hmax]);
    input('press any key to start');
end
for i_t = 2:Nt
    u_prev = u_prev - (g * dt) * diff_center(h, [0, 1], dx);
    v_prev = v_prev - (g * dt) * diff_center(h, [-1, 0], dy);
    h_prev = h_prev - (H * dt) * (diff_center(u, [0, 1], dx) + diff_center(v, [-1, 0], dy));
    
    % this might be inefficient because swap will allocate NxN array every
    % time
    [u, u_prev] = deal(u_prev, u);
    [v, v_prev] = deal(v_prev, v);
    [h, h_prev] = deal(h_prev, h);
    
    h_th = cos(i_t * dt * v0) * (cos(X) + cos(Y));
    r(i_t) = sum(sum((h - h_th).^2)) / N^2;
    
    if(draw_evol)
        if(mod(i_t, 10) == 0)
            delete(srf);
            delete(srf_th);
            srf = surf(ax, X, Y, h,...
                'EdgeColor', 'interp', 'FaceColor', 'interp', 'DisplayName', 'numerical');
            srf_th = surf(ax, X, Y, h_th, ...
                'EdgeColor', 'interp', 'FaceColor', 'interp', 'DisplayName', 'theory');
            zlim([-hmax, hmax]);
            caxis([-hmax, hmax]);
            pause(0.001);
        end    
    end
    disp(i_t / Nt);
end

if(draw_err)
    getFig('t', '$< r^2 >$', 'err(t)', 'log', 'log');
    %getFig('t', '$< r^2 >$', 'err(t)');
    plot((1:Nt)*dt, r, 'DisplayName', 'error');
    plot([1, 1] * (2*pi / v0), [1e-5, max(r) / 2], 'DisplayName', 'period');
end