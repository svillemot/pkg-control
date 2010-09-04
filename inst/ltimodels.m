## Copyright (C) 2009   Luca Favatella
##
## This file is part of LTI Syncope.
##
## LTI Syncope is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## LTI Syncope is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program. If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} test ltimodels
## @deftypefnx {Function File} ltimodels
## @deftypefnx {Function File} ltimodels (@var{systype})
## Test suite and help for LTI models.
## @end deftypefn

## Author: Luca Favatella <slackydeb@gmail.com>
## Created: November 2009
## Version: 0.1

function ltimodels (systype = "general")

  %if (nargin > 1)
    print_usage ();
  %endif

  if (! ischar (systype))
    error ("ltimodels: argument must be a string");
  endif

  systype = lower (systype);

  switch (systype)
    case "ss"
      str = {"State Space (SS) Models"\
             "-----------------------"\
             ""};

    case "tf"
      str = {"Transfer Function (TF) Models"\
             "-----------------------------"\
             ""};

    otherwise  # general
      str = {"Linear Time Invariant (LTI) Models"\
             "----------------------------------"\
             ""};

  endswitch

  disp ("");
  disp (char (str));

endfunction


## isct, isdt
%!shared ltisys
%! ltisys = tf (12);
%!assert (ltisys.ts, -1);
%!assert (isct (ltisys));
%!assert (isdt (ltisys));

%!shared ltisys
%! ltisys = ss (17);
%!assert (ltisys.ts, -1);
%!assert (isct (ltisys));
%!assert (isdt (ltisys));

%!shared ltisys
%! ltisys = tf (1, [1 1]);
%!assert (ltisys.ts, 0);
%!assert (isct (ltisys));
%!assert (! isdt (ltisys));

%!shared ltisys, ts
%! ts = 0.1;
%! ltisys = ss (-1, 1, 1, 0, ts);
%!assert (ltisys.ts, ts);
%!assert (! isct (ltisys));
%!assert (isdt (ltisys));

## mtimes
%!shared sysmat, sysmat_exp
%! sys1 = ss ([0, 1; -3, -2], [0; 1], [-5, 1], [2]);
%! sys2 = ss ([-10], [1], [-40], [5]);
%! sys3 = sys2 * sys1;
%! [A, B, C, D] = ssdata (sys3);
%! sysmat = [A, B; C, D];
%! A_exp = [ -10   -5    1
%!             0    0    1
%!             0   -3   -2 ];
%! B_exp = [   2
%!             0
%!             1 ];
%! C_exp = [ -40  -25    5 ];
%! D_exp = [  10 ];
%! sysmat_exp = [A_exp, B_exp; C_exp, D_exp];
%!assert (sysmat, sysmat_exp)

## norm ct
%!shared H2, Hinf
%! sys = ss (-1, 1, 1, 0);
%! H2 = norm (sys, 2);
%! Hinf = norm (sys, inf);
%!assert (H2, 0.7071, 1.5e-5);
%!assert (Hinf, 1, 5e-4);

## norm dt
%!shared H2, Hinf
%! a = [ 2.417   -1.002    0.5488
%!           2        0         0
%!           0      0.5         0 ];
%! b = [     1
%!           0
%!           0 ];
%! c = [-0.424    0.436   -0.4552 ];
%! d = [     1 ];
%! sys = ss (a, b, c, d, 0.1);
%! H2 = norm (sys, 2);
%! Hinf = norm (sys, inf);
%!assert (H2, 1.2527, 1.5e-5);
%!assert (Hinf, 2.7, 0.1);

## transmission zeros of state-space models

## Results from the "Dark Side" 7.5 and 7.8
##
##  -13.2759
##   12.5774
##  -0.0155

## Results from Scilab 5.2.0b1 (trzeros)
##
##  - 13.275931  
##    12.577369  
##  - 0.0155265

%!shared z, z_exp
%! A = [   -0.7   -0.0458     -12.2        0
%!            0    -0.014   -0.2904   -0.562
%!            1   -0.0057      -1.4        0
%!            1         0         0        0 ];
%!
%! B = [  -19.1      -3.1
%!      -0.0119   -0.0096
%!        -0.14     -0.72
%!            0         0 ];
%!
%! C = [      0         0        -1        1
%!            0         0     0.733        0 ];
%!
%! D = [      0         0
%!       0.0768    0.1134 ];
%!
%! sys = ss (A, B, C, D);
%! z = sort (zero (sys));
%!
%! z_exp = sort ([-13.2759; 12.5774; -0.0155]);
%!
%!assert (z, z_exp, 1e-4);

## inverse of state-space models
## test from SLICOT AB07ND
## note the negative signs in Me for compatibility reasons
%!shared M, Me
%! A = [ 1.0   2.0   0.0
%!       4.0  -1.0   0.0
%!       0.0   0.0   1.0 ];
%!
%! B = [ 1.0   0.0
%!       0.0   1.0
%!       1.0   0.0 ];
%!
%! C = [ 0.0   1.0  -1.0
%!       0.0   0.0   1.0 ];
%!
%! D = [ 4.0   0.0
%!       0.0   1.0 ];
%!
%! sys = ss (A, B, C, D);
%! sysinv = inv (sys);
%! [Ai, Bi, Ci, Di] = ssdata (sysinv);
%! M = [Ai, Bi; Ci, Di];
%!
%! Ae = [ 1.0000   1.7500   0.2500
%!        4.0000  -1.0000  -1.0000
%!        0.0000  -0.2500   1.2500 ];
%!
%! Be = [-0.2500   0.0000
%!        0.0000  -1.0000
%!       -0.2500   0.0000 ];
%!
%! Ce = [ 0.0000   0.2500  -0.2500
%!        0.0000   0.0000   1.0000 ];
%!
%! De = [ 0.2500   0.0000
%!        0.0000   1.0000 ];
%!
%! Me = [Ae, -Be; -Ce, De];
%!
%!assert (M, Me, 1e-4);

## ss: minreal
%!shared C, D
%!
%! A = ss (-2, 3, 4, 5);
%! B = A / A;
%! C = minreal (B);
%! D = ss (1);
%!
%!assert (C.a, D.a);
%!assert (C.b, D.b);
%!assert (C.c, D.c);
%!assert (C.d, D.d);

## tf: minreal
%!shared a, b, c, d
%! s = tf ("s");
%! G1 = (s+1)*s*5/(s+1)/(s^2+s+1);
%! G2 = tf ([1, 1, 1], [2, 2, 2]);
%! G1min = minreal (G1);
%! G2min = minreal (G2);
%! a = G1min.num{1, 1};
%! b = G1min.den{1, 1};
%! c = G2min.num{1, 1};
%! d = G2min.den{1, 1};
%!assert (a, [5, 0], 1e-4);
%!assert (b, [1, 1, 1], 1e-4);
%!assert (c, 0.5, 1e-4);
%!assert (d, 1, 1e-4);

## lti: subsref
%!shared a
%! s = tf ("s");
%! G = (s+1)*s*5/(s+1)/(s^2+s+1);
%! a = G(1,1).num{1,1}(1);
%!assert (a, 5, 1e-4);

## staircase (SLICOT AB01OD)
%!shared Ac, Bc, Ace, Bce
%! A = [ 17.0   24.0    1.0    8.0   15.0
%!       23.0    5.0    7.0   14.0   16.0
%!        4.0    6.0   13.0   20.0   22.0
%!       10.0   12.0   19.0   21.0    3.0
%!       11.0   18.0   25.0    2.0    9.0];
%!
%! B = [ -1.0   -4.0
%!        4.0    9.0
%!       -9.0  -16.0
%!       16.0   25.0
%!      -25.0  -36.0];
%!
%! tol = 0;
%!
%! A = A.';  # There's a little mistake in the example
%!           # program of routine AB01OD in SLICOT 5.0
%!
%! [Ac, Bc, U, ncont] = slab01od (A, B, tol);
%!
%! Ace = [ 12.8848   3.2345  11.8211   3.3758  -0.8982
%!          4.4741 -12.5544   5.3509   5.9403   1.4360
%!         14.4576   7.6855  23.1452  26.3872 -29.9557
%!          0.0000   1.4805  27.4668  22.6564  -0.0072
%!          0.0000   0.0000 -30.4822   0.6745  18.8680];
%!
%! Bce = [ 31.1199  47.6865
%!          3.2480   0.0000
%!          0.0000   0.0000
%!          0.0000   0.0000
%!          0.0000   0.0000];
%!
%!assert (Ac, Ace, 1e-4);
%!assert (Bc, Bce, 1e-4);