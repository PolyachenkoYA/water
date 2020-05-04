function s = state_mult(s, a)
    s.h = s.h * a;
    s.u = s.u * a;
    s.w = s.w * a;
end