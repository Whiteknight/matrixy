.namespace ["_Matrixy";"builtins"]

.sub 'ceil'
    .param int nargout
    .param int nargin
    .param pmc x

$S0 = <<"EOS"
.sub '' :anon
    .param int nargout
    .param int nargin
    .param pmc x
    $N0 = x
    $I0 = ceil $N0
    .return($I0)
.end
EOS

    $P0 = compreg "PIR"
    $P1 = $P0($S0)
    $P2 = $P1[0]
    $P3 = '!lookup_function'('arrayfun')
    $P4 = $P3(1,1,$P2,x)
    .return($P4)
.end

