.namespace ["_Matrixy";"builtins"]

.sub 'round'
    .param int nargout
    .param int nargin
    .param pmc matrix
    .const Sub helper = "__round_helper"

    $S0 = typeof x
    if $S0 == 'NumMatrix2D' goto _have_matrix
    .return(x)

  _have_matrix:
    .local pmc new_matrix
    new_matrix = clone matrix
    new_matrix.'iterate_function_inplace'(helper)
.end

.sub '__round_helper' :anon
    .param num x
    $N0 = x
    $N1 = $N0 + 0.5
    $I0 = floor $N1
    $N2 = $I0
    .return($N2)
.end
