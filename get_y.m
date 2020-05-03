function y_new = get_y(ys_fnc, x, eta, y0)
    y_new = eta * y0 + ys_fnc(x) .* (1 - eta);
end