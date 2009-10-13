.namespace ["_Matrixy";"builtins"]

=item parrot_typeof(PMC a)

Return a string representing the Parrot type of the parameter a

=cut

.sub 'parrot_typeof'
    .param int nargout
    .param int nargin
    .param pmc a
    $S0 = typeof a
    .return($S0)
.end
