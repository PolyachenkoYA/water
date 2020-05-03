function y_derv = get_ys_derv(x, y1, x1, sgm, L)
    exp_var = exp(-(x-x1).^2 / sgm^2);
    y_derv = exp_var.*(L-x).*x.*(x.*(x.*(x-x1)-2*sgm^2) + (x.*(x1-x)+sgm^2)*L) * (2 / sgm^2);
    ys_notNorm = exp_var .* (x .* (L - x)).^2;
    y_derv = y_derv * (y1 / max(ys_notNorm, [], 'all'));
end

