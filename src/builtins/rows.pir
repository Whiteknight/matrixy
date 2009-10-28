.namespace ["_Matrixy";"builtins"]

.sub 'rows'
    .param int nargout
    .param int nargin
    .param pmc matrix

    $S0 = typeof matrix
    if $S0 == 'NumMatrix2D' goto _its_an_array
    .return(1)

  _its_an_array:
    .local pmc y
    y = get_attr "Y"
    .return(y)
.end

