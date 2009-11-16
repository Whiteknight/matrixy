.namespace['_Matrixy';'builtins']

.sub 'lasterr'
    .param int nargout
    .param int nargin
    $P0 = get_hll_global ['Matrixy';'Grammar';'Actions'], '$?LASTERR'
    $P1 = $P0['message']
    .return($P1)
.end

.namespace []
