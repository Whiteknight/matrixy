=item zeros(n, m)

Create an n x m matrix of zeros.

=cut


.sub 'zeros'
    .param int nargout
    .param int nargin
    .param int rows
    .param int cols
    $I0 = rows + 1
    $I1 = cols + 1

    # NumMatrix2D zero-fills by default
    $P0 = new ['NumMatrix2D']

    $P0[$I0;$I1] = 0.0
    .return($P0)
.end


