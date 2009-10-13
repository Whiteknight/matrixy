.namespace ["_Matrixy";"builtins"]

.sub 'read'
    .param int nargout
    .param int nargin
    $P0 = getstdin
    $S0 = readline $P0
    .return ($S0)
.end

.namespace []

