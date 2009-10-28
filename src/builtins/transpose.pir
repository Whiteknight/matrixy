=item transpose(A)

This function returns the transpose of A and is equivalent to A.'

=cut

.namespace ["_Matrixy";"builtins"]

.sub 'transpose'
    .param int nargout
    .param int nargin
    .param pmc A

    $S0 = typeof A
    if $S0 == 'NumMatrix2D' goto process_array
    .return (A)

  process_array:
    A.'transpose'()
    .return (A)
.end


