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

  have_sub:
    $S0 = typeof A
    if $S0 == 'NumMatrix2D' goto its_a_matrix
    $I0 = elements O
    $I0 = $I0 + 1
    $P0 = f(1, $I0, A, O :flat)
    .return($P0)

  its_a_matrix:
    .lex "function", f
    A.'iterate_function_inplace'(helper, O :flat)
    .return(A)
.end

.sub '!_arrayfun_helper' :outer('arrayfun')
    .param pmc matrix
    .param num value
    .param int x
    .param int y
    $P0 = find_lex "function"
    .tailcall $P0(value)
.end
