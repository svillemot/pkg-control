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
## @deftypefn {Function File} {[@var{x}, @var{l}, @var{g}] =} dare (@var{a}, @var{b}, @var{q}, @var{r})
## @deftypefnx {Function File} {[@var{x}, @var{l}, @var{g}] =} dare (@var{a}, @var{b}, @var{q}, @var{r}, @var{s})
## Return unique stabilizing solution x of the discrete-time
## Riccati equation as well as the closed-loop poles l and the
## corresponding gain matrix g.
## Uses SLICOT SB02OD by courtesy of NICONET e.V.
## <http://www.slicot.org>
## @example
## @group
##                           -1
## A'XA - X - A'XB (B'XB + R)   B'XA + Q = 0
##
##                                 -1
## A'XA - X - (A'XB + S) (B'XB + R)   (A'XB + S)' + Q = 0
##
##               -1
## G = (B'XB + R)   B'XA
##
##               -1
## G = (B'XB + R)   (B'XA + S')
## @end group
## @end example
## @seealso{care, lqr, dlqr, kalman}
## @end deftypefn

## Author: Lukas Reichlin <lukas.reichlin@gmail.com>
## Created: October 2009
## Version: 0.3

function [x, l, g] = dare (a, b, q, r, s = [])

  ## TODO: Add SLICOT SG02AD (Solution of continuous- or discrete-time
  ##       algebraic Riccati equations for descriptor systems)

  if (nargin < 4 || nargin > 5)
    print_usage ();
  endif

  if (! issquare (a))
    error ("dare: a is not square");
  endif

  if (! issquare (q))
    error ("dare: q is not square");
  endif

  if (! issquare (r))
    error ("dare: r is not square");
  endif
  
  if (rows (a) != rows (b))
    error ("dare: (a, b) not conformable");
  endif
  
  if (columns (r) != columns (b))
    error ("dare: (b, r) not conformable");
  endif

  if (! isempty (s) && any (size (s) != size (b)))
    error ("dare: s (%dx%d) must be identically dimensioned with b (%dx%d)",
            rows (s), columns (s), rows (b), columns (b));
  endif
  
  ## check stabilizability
  if (! isstabilizable (a, b, [], 1))
    error ("dare: (a, b) not stabilizable");
  endif

  ## check positive semi-definiteness
  if (isempty (s))
    t = zeros (size (b));
  else
    t = s;
  endif

  m = [q, t; t.', r];

  if (isdefinite (m) < 0)
    error ("dare: require [q, s; s.', r] >= 0");
  endif

  ## solve the riccati equation
  if (isempty (s))
    ## unique stabilizing solution
    x = slsb02od (a, b, q, r, b, true, false);
    
    ## corresponding gain matrix
    g = (r + b.'*x*b) \ (b.'*x*a);
  else
    ## unique stabilizing solution
    x = slsb02od (a, b, q, r, s, true, true);
    
    ## corresponding gain matrix
    g = (r + b.'*x*b) \ (b.'*x*a + s.');
  endif

  ## closed-loop poles
  l = eig (a - b*g);
  
  ## TODO: use alphar, alphai and beta from SB02OD

endfunction


## TODO: add a test