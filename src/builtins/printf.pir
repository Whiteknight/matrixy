.namespace ["_Matrixy";"builtins"]

.sub 'printf'
    .param int nargout
    .param int nargin
    .param pmc fmt
    .param pmc args     :slurpy

    $P0 = new 'String'
    sprintf $P0, fmt, args
    print $P0

.end



