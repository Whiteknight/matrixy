.namespace ["_Matrixy";"builtins"]

.sub 'columns'
    .param int nargout
    .param int nargin
    .param pmc x
    $S0 = typeof x
    if $S0 == 'NumMatrix2D' goto _its_an_array
    .return(1)
  _its_an_array:
    $I0 = getattribute "X"
    .return($I0)
.end