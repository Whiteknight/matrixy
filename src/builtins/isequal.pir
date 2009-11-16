=item isequal(A, B, C, ...)


=cut

.namespace ['_Matrixy';'builtins']

.sub 'isequal'
    .param int nargout
    .param int nargin
    .param pmc X
    .param pmc Y
    .param pmc others :slurpy

    $I0 = X == Y
    if $I0 == 0 goto not_equal
    $P0 = iter others
  loop_top:
    unless $P0 goto loop_bottom
    $P1 = shift $P0
    $I0 = $P1 == X
    if $I0 == 0 goto not_equal
    goto loop_top
  loop_bottom:
    .return(1)
  not_equal:
    .return(0)
.end
