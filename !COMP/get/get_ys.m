function y = get_ys(x, y1, x1, sgm, L)
    y = exp(-(x - x1).^2 / sgm^2) .* (x .* (L - x)).^2;
    y = y * (y1 / max(y, [], 'all'));
end

