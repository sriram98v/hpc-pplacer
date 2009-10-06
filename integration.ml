(* pplacer v0.3. Copyright (C) 2009  Frederick A Matsen.
 * This file is part of pplacer. pplacer is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. pplacer is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with pplacer. If not, see <http://www.gnu.org/licenses/>.
 *)

(*
from http://www.gnu.org/software/gsl/manual/gsl-ref.html#Numerical-Integration ...


Each algorithm computes an approximation to a definite integral of the form,

     I = \int_a^b f(x) w(x) dx

where w(x) is a weight function (for general integrands w(x)=1). The user provides absolute and relative error bounds (epsabs, epsrel) which specify the following accuracy requirement,

     |RESULT - I|  <= max(epsabs, epsrel |I|)

where RESULT is the numerical approximation obtained by the algorithm. The algorithms attempt to estimate the absolute error ABSERR = |RESULT - I| in such a way that the following inequality holds,

     |RESULT - I| <= ABSERR <= max(epsabs, epsrel |I|)

In short, the routines return the first approximation which has an absolute error smaller than epsabs or a relative error smaller than epsrel.

Note that this is an either-or constraint, not simultaneous. To compute to a specified absolute error, set epsrel to zero. To compute to a specified relative error, set epsabs to zero. The routines will fail to converge if the error bounds are too stringent, but always return the best approximation obtained up to that stage. 

*)


let value_of_triple (v, _, _) = v

(* non-adaptive Gauss-Kronrod integration *)
let integrate f a b ~abs_err ~rel_err = 
  Gsl_integration.qng f ~a:a ~b:b ~epsabs:abs_err ~epsrel:rel_err 
    
let value_integrate f a b ~abs_err ~rel_err = 
  value_of_triple (integrate f a b ~abs_err ~rel_err)


(* testing....

  (*
   In[5]:= N[Log[Integrate[Exp[-x^2 -y^3], {x,0,1}, {y,2,4}]]]
   Out[5]= -10.8494
   *)

let twoDF x y = -.x*.x -.y*.y*.y
let x = twoDIntegrateLL twoDF (twoDF 0. 2.) 0. 1. 2. 4. 0.1

*)
