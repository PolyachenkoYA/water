function eta = get_eta(x, y, ys_fnc, y0)
    ys = ys_fnc(x);
    eta = (y - ys) ./ (ones(size(y)) * y0 - ys);
end

