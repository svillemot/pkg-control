/*

Copyright (C) 2009 - 2010   Lukas F. Reichlin

This file is part of LTI Syncope.

LTI Syncope is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

LTI Syncope is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

H-infinity (sub)optimal state controller for a continuous-time system.
Uses SLICOT SB10FD by courtesy of NICONET e.V.
<http://www.slicot.org>

Author: Lukas Reichlin <lukas.reichlin@gmail.com>
Created: December 2009
Version: 0.3

*/

#include <octave/oct.h>
#include <f77-fcn.h>
#include "common.cc"

extern "C"
{ 
    int F77_FUNC (sb10fd, SB10FD)
                 (int& N, int& M, int& NP,
                  int& NCON, int& NMEAS,
                  double& GAMMA,
                  double* A, int& LDA,
                  double* B, int& LDB,
                  double* C, int& LDC,
                  double* D, int& LDD,
                  double* AK, int& LDAK,
                  double* BK, int& LDBK,
                  double* CK, int& LDCK,
                  double* DK, int& LDDK,
                  double* RCOND,
                  double& TOL,
                  int* IWORK,
                  double* DWORK, int& LDWORK,
                  bool* BWORK,
                  int& INFO);
}
     
DEFUN_DLD (slsb10fd, args, nargout, "Slicot SB10FD Release 5.0")
{
    int nargin = args.length ();
    octave_value_list retval;
    
    if (nargin != 7)
    {
        print_usage ();
    }
    else
    {
        // arguments in
        Matrix a = args(0).matrix_value ();
        Matrix b = args(1).matrix_value ();
        Matrix c = args(2).matrix_value ();
        Matrix d = args(3).matrix_value ();
        
        int ncon = args(4).int_value ();
        int nmeas = args(5).int_value ();
        double gamma = args(6).double_value ();
        
        int n = a.rows ();      // n: number of states
        int m = b.columns ();   // m: number of inputs
        int np = c.rows ();     // np: number of outputs
        
        int lda = max (1, a.rows ());
        int ldb = max (1, b.rows ());
        int ldc = max (1, c.rows ());
        int ldd = max (1, d.rows ());
        
        int ldak = max (1, n);
        int ldbk = max (1, n);
        int ldck = max (1, ncon);
        int lddk = max (1, ncon);
        
        double tol = 0;
        
        // arguments out
        Matrix ak (ldak, n);
        Matrix bk (ldbk, nmeas);
        Matrix ck (ldck, n);
        Matrix dk (lddk, nmeas);
        ColumnVector rcond (4);
        
        // workspace
        
        int m2 = ncon;
        int m1 = m - m2;
        int np1 = np - nmeas;
        int np2 = nmeas;
        
        int liwork = max (2*max (n, m-ncon, np-nmeas, ncon), n*n);
        int q = max (m1, m2, np1, np2);
        int ldwork = 2*q*(3*q+2*n) + max (1, (n+q)*(n+q+6), q*(q + max (n, q, 5) + 1),
                                          2*n*(n+2*q) + max (1, 4*q*q +
                                          max (2*q, 3*n*n + max (2*n*q, 10*n*n+12*n+5)),
                                          q*(3*n + 3*q + max (2*n, 4*q + max (n, q)))));

        OCTAVE_LOCAL_BUFFER (int, iwork, liwork);
        OCTAVE_LOCAL_BUFFER (double, dwork, ldwork);
        OCTAVE_LOCAL_BUFFER (bool, bwork, 2*n);
        
        // error indicator
        int info;


        // SLICOT routine SB10FD
        F77_XFCN (sb10fd, SB10FD,
                 (n, m, np,
                  ncon, nmeas,
                  gamma,
                  a.fortran_vec (), lda,
                  b.fortran_vec (), ldb,
                  c.fortran_vec (), ldc,
                  d.fortran_vec (), ldd,
                  ak.fortran_vec (), ldak,
                  bk.fortran_vec (), ldbk,
                  ck.fortran_vec (), ldck,
                  dk.fortran_vec (), lddk,
                  rcond.fortran_vec (),
                  tol,
                  iwork,
                  dwork, ldwork,
                  bwork,
                  info));

        if (f77_exception_encountered)
            error ("hinfsyn: slsb10fd: exception in SLICOT subroutine SB10FD");

        if (info != 0)
            error ("hinfsyn: slsb10fd: SB10FD returned info = %d", info);
        
        // return values
        retval(0) = ak;
        retval(1) = bk;
        retval(2) = ck;
        retval(3) = dk;
    }
    
    return retval;
}