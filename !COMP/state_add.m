function s1 = state_add(s1, s2)
    s1.h = s1.h + s2.h;
    s1.u = s1.u + s2.u;
    s1.w = s1.w + s2.w;
end