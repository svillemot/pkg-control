## Copyright (C) 2010   Lukas F. Reichlin
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
## Number of outputs and inputs of transfer function numerator and
## denominator. For internal use only.

## Author: Lukas Reichlin <lukas.reichlin@gmail.com>
## Created: February 2010
## Version: 0.1

function [p, m, l] = __frd_dim__ (H, w)

  if (! isnumeric (H))  # TODO: watch out for __set__ vector case
    error ("frd: H must be a 3-dimensional numeric array");
  endif

  if (! isempty (w) && (! is_real_vector (w) || any (w < 0)))
    error ("frd: w must be a vector of positive real numbers");
  endif

  if (isempty (H))
    p = m = l = 0;
  else
    [p, m, l] = size (H);
  endif

  lw = length (w);

  if (l != lw)
    error ("frd: H (%dx%dx%d) and w (%d) must have equal length",
            p, m, l, lw);
  endif

endfunction