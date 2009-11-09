=item mtimes(A, B)

This function returns the matrix product of A times B
and is equivalent to A * B.

=cut

.namespace ["_Matrixy";"builtins"]

.sub 'mtimes'
    .param int nargout
    .param int nargin
    .param pmc A
    .param pmc B

    $P0 = A * B
    .return($P0)
.end


