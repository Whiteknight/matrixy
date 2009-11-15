=item arrayfun(func, A)

Apply a function 'func' to each element of an array 'A'.

=cut

.namespace ["_Matrixy";"builtins"]

.sub 'arrayfun'
    .param int nargout
    .param int nargin
    .param pmc f
    .param pmc A
    .param pmc O :slurpy
    .const "Sub" helper = "!_arrayfun_helper"
    $S0 = typeof f
    if $S0 == 'Sub' goto have_sub
    $S1 = f
    f = '!lookup_function'($S1)
    if null f goto no_sub_available

  have_sub:
    $S0 = typeof A
    if $S0 == 'NumMatrix2D' goto its_a_matrix
    $I0 = elements O
    $I0 = $I0 + 1
    $P0 = f(1, $I0, A, O :flat)
    .return($P0)

  its_a_matrix:
    $P0 = A.'iterate_function_external'(helper, f, O :flat)
    .return($P0)
  no_sub_available:
    .return(A)
.end

.sub '!_arrayfun_helper'
    .param pmc matrix
    .param num value
    .param int x
    .param int y
    .param pmc subroutine
    .param pmc args :slurpy
    $I0 = args
    .tailcall subroutine(1, $I0, value, args :flat)
.end
