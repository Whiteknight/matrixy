.namespace ["_Matrixy";"builtins"]

.sub 'round'
    .param int nargout
    .param int nargin
    .param pmc matrix
    .const "Sub" helper = "!__round_helper"

    $I0 = '!is_scalar'(matrix)
    if $I0 == 0 goto is_a_matrix
    $N0 = matrix
    $N0 = $N0 + 0.5
    $N1 = floor $N0
    .return($N1)

  is_a_matrix:
    $P0 = matrix.'iterate_function_external'(helper)
    .return($P0)
.end

.sub '!__round_helper' :anon
    .param pmc matrix
    .param num value
    .param int x
    .param int y
    $N1 = value + 0.5
    $I0 = floor $N1
    $N2 = $I0
    .return($N2)
.end
