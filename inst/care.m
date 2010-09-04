## Copyright (C) 2009 - 2010   Lukas F. Reichlin
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
## @deftypefn {Function File} {[@var{x}, @var{l}, @var{g}] =} care (@var{a}, @var{b}, @var{q}, @var{r})
## @deftypefnx {Function File} {[@var{x}, @var{l}, @var{g}] =} care (@var{a}, @var{b}, @var{q}, @var{r}, @var{s})
## Return unique stabilizing solution x of the continuous-time
## Riccati equation as well as the closed-loop poles l and the
## corresponding gain matrix g.
## Uses SLICOT SB02OD by courtesy of NICONET e.V.
## <http://www.slicot.org>
## @example
## @group
##               -1
## A'X + XA - XBR  B'X + Q = 0
## 
##                      -1
## A'X + XA - (XB + S) R  (XB + S)' + Q = 0
##
##      -1
## G = R  B'X
##
##      -1
## G = R  (B'X + S')
## @end group
## @end example
## @seealso{dare, lqr, dlqr, kalman}
## @end deftypefn

## Author: Lukas Reichlin <lukas.reichlin@gmail.com>
## Created: November 2009
## Version: 0.3

function [x, l, g] = care (a, b, q, r, s = [])

  ## TODO: Add SLICOT SG02AD (Solution of continuous- or discrete-time
  ##       algebraic Riccati equations for descriptor systems)

  if (nargin < 4 || nargin > 5)
    print_usage ();
  endif

  if (! issquare (a))
    error ("care: a is not square");
  endif

  if (! issquare (q))
    error ("care: q is not square");
  endif

  if (! issquare (r))
    error ("care: r is not square");
  endif
  
  if (rows (a) != rows (b))
    error ("care: (a, b) not conformable");
  endif
  
  if (columns (r) != columns (b))
    error ("care: (b, r) not conformable");
  endif

  if (! isempty (s) && any (size (s) != size (b)))
    error ("care: s (%dx%d) must be identically dimensioned with b (%dx%d)",
            rows (s), columns (s), rows (b), columns (b));
  endif

  ## check stabilizability
  if (! isstabilizable (a, b, [], 0))
    error ("care: (a, b) not stabilizable");
  endif

  ## check positive semi-definiteness
  if (isempty (s))
    t = zeros (size (b));
  else
    t = s;
  endif

  m = [q, t; t.', r];

  if (isdefinite (m) < 0)
    error ("care: require [q, s; s.', r] >= 0");
  endif

  ## solve the riccati equation
  if (isempty (s))
    ## unique stabilizing solution
    x = slsb02od (a, b, q, r, b, false, false);
    
    ## corresponding gain matrix
    g = r \ (b.'*x);
  else
    ## unique stabilizing solution
    x = slsb02od (a, b, q, r, s, false, true);
    
    ## corresponding gain matrix
    g = r \ (b.'*x + s.');
  endif

  ## closed-loop poles
  l = eig (a - b*g);
  
  ## TODO: use alphar, alphai and beta from SB02OD

endfunction


%!shared x, l, g, xe, le, ge
%! a = [-3   2
%!       1   1];
%!
%! b = [ 0
%!       1];
%!
%! c = [ 1  -1];
%!
%! r = 3;
%!
%! [x, l, g] = care (a, b, c.'*c, r);
%!
%! xe = [ 0.5895    1.8216
%!        1.8216    8.8188];
%!
%! le = [-3.5026
%!       -1.4370];
%!
%! ge = [ 0.6072    2.9396];
%!
%!assert (x, xe, 1e-4);
%!assert (l, le, 1e-4);
%!assert (g, ge, 1e-4);

%!shared x, l, g, xe, le, ge
%! a = [ 0.0  1.0
%!       0.0  0.0];
%!
%! b = [ 0.0
%!       1.0];
%!
%! c = [ 1.0  0.0
%!       0.0  1.0
%!       0.0  0.0];
%!
%! d = [ 0.0
%!       0.0
%!       1.0];
%!
%! [x, l, g] = care (a, b, c.'*c, d.'*d);
%!
%! xe = [ 1.7321   1.0000
%!        1.0000   1.7321];
%!
%! le = [-0.8660 + 0.5000i
%!       -0.8660 - 0.5000i];
%!
%! ge = [ 1.0000   1.7321];
%!
%!assert (x, xe, 1e-4);
%!assert (l, le, 1e-4);
%!assert (g, ge, 1e-4);