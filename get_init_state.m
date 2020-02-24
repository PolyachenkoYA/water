function [h, u, v] = get_init_state(X, Y)
    %u(:) = 0;
    %v(:) = exp(-(((X - 2) / 2).^2 + ((Y - 2) / 1).^2)) .* (Y - dy) .* (X - dx) .* (l - Y) .* (l - X);
    %h = exp(-(((X - 1) / 2).^2 + ((Y - 2) / 1).^2)) .* (Y - dy) .* (X - dx) .* (l - Y) .* (l - X);
    %h = h_prev / max(max(h_prev));
    %v = v_prev / max(max(v_prev)) * 0.5;

    h = cos(X) + cos(Y * 2); % h(t,x,y) = cos(x) * cos(t * v0) + cos(2y) * cos(2t * v0);
    u(:) = 0;
    v(:) = 0;        
end