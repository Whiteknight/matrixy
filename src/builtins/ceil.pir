.namespace ["_Matrixy";"builtins"]

.sub 'ceil'
    .param int nargout
    .param int nargin
    .param pmc matrix
    .const "Sub" helper = "!__ceil_helper"

    $I0 = '!is_scalar'(matrix)
    if $I0 == 0 goto is_a_matrix
    $N0 = matrix
    $N1 = ceil $N0
    .return($N1)

  is_a_matrix:
    $P0 = matrix.'iterate_function_external'(helper)
    .return($P0)
.end

.sub '!__ceil_helper'
    .param pmc matrix
    .param num value
    .param int x
    .param int y
    $I0 = ceil value
    $N0 = $I0
    .return($N0)
.end

