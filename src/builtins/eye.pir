=item eye(n)

Creates an identity matrix of dimension n.

=cut

.namespace ["_Matrixy";"builtins"]

.sub 'eye'
    .param int nargout
    .param int nargin
    .param int dim

    .local pmc A
    A = new 'NumMatrix2D'
    $I0 = dim - 1
    A[$I0;$I0] = 1

  loop_top:
    A[$I0;$I0] = 1
    if $I0 == 0 goto loop_end
    dec $I0
    goto loop_top
  loop_end:
    .return(A)
.end

.namespace []
