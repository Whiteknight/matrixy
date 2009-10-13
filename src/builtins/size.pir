.namespace ["_Matrixy";"builtins"]

.sub 'size'
    .param int nargout
    .param int nargin
    .param pmc x
    $S0 = typeof x
    if $S0 == 'ResizablePMCArray' goto _its_an_array
    .return(1)
  _its_an_array:
    $P0 = find_name '!get_matrix_sizes'
    $P1 = $P0(x)
    $P0 = find_name '!array_row'
    $P2 = $P0($P1 :flat)
    $P0 = find_name '!array_col'
    .tailcall $P0($P2)
.end
