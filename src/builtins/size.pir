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
    .local int x
    x = get_attr "X"
    .local int y
    y = get_attr "Y"
    result[0;0] = x
    result[0;1] = y
    .return(result)
.end
