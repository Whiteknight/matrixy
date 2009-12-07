.namespace ["_Matrixy";"builtins"]

.sub 'columns'
    .param int nargout
    .param int nargin
    .param pmc matrix

    $I0 = does matrix, "matrix"
    if $I0 == 1 goto _its_a_matrix
    .return(1)
  _its_a_matrix:
    $P1 = getattribute matrix, "cols"
    $I0 = $P1
    .return($I0)
.end
