.namespace ["_Matrixy";"builtins"]

.sub 'columns'
    .param int nargout
    .param int nargin
    .param pmc matrix

    $P0 = matrix
    $S0 = typeof $P0
    if $S0 == 'NumMatrix2D' goto _its_an_array
    .return(1)
  _its_an_array:
    $P1 = getattribute $P0, "X"
    $I0 = $P1
    .return($I0)
.end
