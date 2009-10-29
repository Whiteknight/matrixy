.namespace ["_Matrixy";"builtins"]

.sub 'ceil'
    .param int nargout
    .param int nargin
    .param pmc matrix
    .const Sub helper = "!_ceil_helper"

    $P0 = clone matrix
    $P0.'iterate_function_inplace'(helper)
    .return($P0)
.end

.sub '!_ceil_helper'
    .param pmc matrix
    .param num x
    $I0 = ceil x
    $N0 = $I0
    .return($N0)
.end

