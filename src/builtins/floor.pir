.namespace ["_Matrixy";"builtins"]

.sub 'floor'
    .param int nargout
    .param int nargin
    .param pmc matrix
    .const "Sub" helper = "!__floor_helper"

    $I0 = '!is_scalar'(matrix)
    if $I0 == 0 goto is_a_matrix
    $N0 = matrix
    $N1 = floor $N0
    .return($N1)
  is_a_matrix:
    $P0 = matrix.'iterate_function_external'(helper)
    .return($P0)
.end

.sub '!__floor_helper' :anon
    .param pmc matrix
    .param num value
    .param int x
    .param int y
    $I0 = floor value
    .return($I0)
.end
