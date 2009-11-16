=item zeros(n, m)

Create an n x m matrix of zeros.

=cut


.sub 'zeros'
    .param int nargout
    .param int nargin
    .param int rows
    .param int cols

    # NumMatrix2D zero-fills by default
    $P0 = new ['NumMatrix2D']
    $P0.'resize'(cols, rows)
    .return($P0)
.end


