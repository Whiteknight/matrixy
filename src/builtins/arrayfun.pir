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

    $S0 = typeof f
    if $S0 == 'Sub' goto main
    $S1 = f
    f = '!lookup_function'($S1)

  main:
    A.'iterate_function_inplace'(f, O :slurpy)
    .return(A)
.end


