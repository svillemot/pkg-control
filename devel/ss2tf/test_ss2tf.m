a = [ -1.0   0.0   0.0
       0.0  -2.0   0.0
       0.0   0.0  -3.0 ];

b = [  0.0   1.0  -1.0
       1.0   1.0   0.0 ].';

c = [  0.0   1.0   1.0
       1.0   1.0   1.0 ];

d = [  1.0   0.0
       0.0   1.0 ];

[gn, gd] = sltb04bd (a, b, c, d)

[gn, gd, ign, igd] = sltb04bd (-2, 3, 4, 5)


% for i = 1 : size (gn, 1)
%   for j = 1 : size (gn, 2)
%     gn(i, j, :)
%     gd(i, j, :)
%   endfor
% endfor


P = tf (1, [1 5 11 14 11 5 1]);

S = ss (P);

[num, den, ign, igd] = sltb04bd (S.a, S.b, S.c, S.d)

P



[num, den, ign, igd] = sltb04bd (0, 1, 1, 0)


sys = WestlandLynx;

[num, den, ign, igd] = sltb04bd (sys.a, sys.b, sys.c, sys.d);