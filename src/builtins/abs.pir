.namespace ["_Matrixy";"builtins"]

.sub 'abs'
    .param int nargout
    .param int nargin
    .param pmc x

$S0 = <<"EOS"
.sub '' :anon
    .param int nargout
    .param int nargin
    .param pmc x
    
    $P0 = abs x
    .return($P0)
.end
EOS

    $P0 = compreg "PIR"
    $P1 = $P0($S0)
    $P2 = $P1[0]
    $P3 = '!lookup_function'('arrayfun')
    $P4 = $P3(1,1,$P2,x)
    .return($P4)
.end

