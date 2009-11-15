=item transpose(A)

This function returns the transpose of A and is equivalent to A.'

=cut

.namespace ["_Matrixy";"builtins"]

.sub 'transpose'
    .param int nargout
    .param int nargin
    .param pmc A

    $I0 = '!is_scalar'(A)
    if $I0 == 0 goto process_array
    .return (A)

  process_array:
    $P0 = clone A
    $P0.'transpose'()
    .return ($P0)
.end


