.namespace ["_Matrixy";"builtins"]

.sub 'size'
    .param int nargout
    .param int nargin
    .param pmc matrix
    .local pmc result
    result = new ['NumMatrix2D']

    $S0 = typeof matrix
    if $S0 == 'NumMatrix2D' goto _its_an_array
    result[0;0] = 1
    result[0;1] = 1
    .return(result)

  _its_an_array:
    $P0 = getattribute matrix, "X"
    $P1 = getattribute matrix, "Y"
    result[0;0] = $P0
    result[0;1] = $P1
    .return(result)
.end
