.namespace ["_Matrixy";"builtins"]

.sub 'floor'
    .param int nargout
    .param int nargin
    .param pmc matrix
    .const "Sub" helper = "!_floor_helper"

    $P0 = matrix.'iterate_function_external'(helper)
    .return($P0)
.end

.sub '!_floor_helper' :anon
    .param pmc matrix
    .param num value
    .param int x
    .param int y
    $I0 = floor value
    .return($I0)
.end
