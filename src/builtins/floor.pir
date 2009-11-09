.namespace ["_Matrixy";"builtins"]

.sub 'floor'
    .param int nargout
    .param int nargin
    .param pmc matrix
    .const Sub helper = "!_floor_helper"

    $P0 = clone matrix
    $P0.'iterate_function_inplace'(helper)
    .return($P0)
.end

.sub '!_floor_helper' :anon
    .param pmc matrix
    .param num matrix
    .param int x
    .param int y
    $N0 = matrix
    $I0 = floor $N0
    .return($I0)
.end
