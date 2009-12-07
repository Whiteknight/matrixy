.namespace ["_Matrixy";"builtins"]

.sub 'rows'
    .param int nargout
    .param int nargin
    .param pmc matrix

    $I0 = does matrix, "matrix"
    if $I0 == 1 goto _its_a_matrix
    .return(1)

  _its_a_matrix:
    $P0 = getattribute matrix, "rows"
    $I0 = $P0
    .return($I0)
.end

