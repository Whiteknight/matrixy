.namespace ["_Matrixy";"builtins"]

=item error(STRING msg)

raises an exception with the supplied message

=cut

.sub 'error'
    .param int nargout
    .param int nargin
    .param pmc msg
    $S0 = '!get_first_string'(msg)
    $S1 = $S0
    $P1 = new 'Exception'
    $P1['message'] = $S1
    throw  $P1
    .return ()
.end
