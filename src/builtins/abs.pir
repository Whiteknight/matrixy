.namespace ["_Matrixy";"builtins"]

.sub 'abs'
    .param int nargout
    .param int nargin
    .param pmc matrix
    .const "Sub" helper = '!_abs_helper'

    $P0 = clone matrix
    $P0.'iterate_function_inplace'(helper)

    .return($P0)
.end

.sub '!_abs_helper'
    .param pmc matrix
    .param num value
    .param int x
    .param int y
    $N0 = abs value
    .return($N0)
.end

