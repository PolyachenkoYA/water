function b = diff1(a, n, dim)
    if(n == 1)
        b = diff(a, 1, dim);
    else
        if(dim == 1)
            b = a(n+1:end, :) - a(1:end-n, :);
        else  % dim == 2
            b = a(:, n+1:end) - a(:, 1:end-n);
        end
    end
end