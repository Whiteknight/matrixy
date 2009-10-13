.namespace ["_Matrixy";"builtins"]

.sub 'columns'
    .param int nargout
    .param int nargin
    .param pmc x
    $S0 = typeof x
    if $S0 == 'ResizablePMCArray' goto _its_an_array
    .return(1)
  _its_an_array:
    $P0 = find_name '!get_matrix_sizes'
    $P1 = $P0(x)
    $I0 = $P1[1]
    .return($I0)
.end