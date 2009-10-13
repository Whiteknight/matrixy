.namespace ["_Matrixy";"builtins"]

.sub 'i'
    .param int nargout
    .param int nargin

    $P0 = new 'Complex'
    $P0 = "1i"
    .return ($P0)
.end


.sub 'j'
    .param int nargout
    .param int nargin

    $P0 = new 'Complex'
    $P0 = "1i"
    .return ($P0)
.end


.sub 'conj'
    .param int nargout
    .param int nargin
    .param pmc x

$S0 = <<"EOS"
.sub '' :anon
    .param int nargout
    .param int nargin
    .param pmc z
    $S0 = typeof z
    unless $S0 == 'Complex' goto return_conj 
    $N0 = z["imag"]
    $N0 = $N0 * -1
    z["imag"] = $N0
    return_conj:
    .return(z)
.end
EOS

    $P0 = compreg "PIR"
    $P1 = $P0($S0)
    $P2 = $P1[0]
    $P3 = '!lookup_function'('arrayfun')
    $P4 = $P3(1,1,$P2,x)
    .return($P4)
.end

