function [h, u, v] = get_init_state(X, Y)
    N = size(X, 1);    
    dy = abs(Y(1,1) - Y(2,2));
    dx = abs(X(1,1) - X(2,2));
    l = abs(X(1,1) - X(end, end)) * (N / (N - 1));
    
    switch(1)
        case 1
            u = zeros(N, N);
            v = exp(-(((X - 2) / 2).^2 + ((Y - 2) / 1).^2)) .* (Y - dy) .* (X - dx) .* (l - Y) .* (l - X);
            h = exp(-(((X - 1) / 2).^2 + ((Y - 2) / 1).^2)) .* (Y - dy) .* (X - dx) .* (l - Y) .* (l - X);
            h = h / max(max(h));
            v = v / max(max(v)) * 0.5;            
        case 2
            h = cos(X) + cos(Y * 2); % h(t,x,y) = cos(x) * cos(t * v0) + cos(2y) * cos(2t * v0);
            u = zeros(N, N);
            v = zeros(N, N);            
    end

end