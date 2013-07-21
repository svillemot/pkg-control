## Copyright (C) 2013   Lukas F. Reichlin
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
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with LTI Syncope.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{z} =} tzero (@var{sys})
## Compute transmission zeros of LTI model.
## Transmission zeros are a subset of the invariant zeros
## as computed by @command{zero}.  See paper [1] for details.
##
## @strong{Inputs}
## @table @var
## @item sys
## LTI model.
## @end table
##
## @strong{Outputs}
## @table @var
## @item z
## Transmission zeros of @var{sys} as defined in [1].
## @end table
##
## @strong{Algorithm}@*
## @command{tzero} uses @code{z=zero(minreal(sys))}.
##
## @strong{Reference}@*
## [1] MacFarlane, A. and Karcanias, N.
## @cite{Poles and zeros of linear multivariable systems:
## a survey of the algebraic, geometric and complex-variable
## theory}.  Int. J. Control, vol. 24, pp. 33-74, 1976.@*
##
## @seealso{zero}
## @end deftypefn

## Author: Lukas Reichlin <lukas.reichlin@gmail.com>
## Created: July 2013
## Version: 0.1

function zer = tzero (sys)

  if (nargin > 1)
    print_usage ();
  endif

  zer = zero (minreal (sys));

endfunction


## Example taken from Paper [1]
%!shared zo, ze
%! A = diag ([1, 1, 3, -4, -1, 3]);
%! 
%! B = [  0,  -1
%!       -1,   0
%!        1,  -1
%!        0,   0
%!        0,   1
%!       -1,  -1  ];
%!        
%! C = [  1,  0,  0,  1,  0,  0
%!        0,  1,  0,  1,  0,  1
%!        0,  0,  1,  0,  0,  1  ];
%!         
%! D = zeros (3, 2);
%! 
%! SYS = ss (A, B, C, D);
%! zo = tzero (SYS);
%! 
%! ze = [2];
%! 
%!assert (zo, ze, 1e-4); 