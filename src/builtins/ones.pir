=item ones(n, m)

Create an n x m matrix of ones.

=cut


.sub 'ones'
    .param int nargout
    .param int nargin
    .param int rows
    .param int cols

    .local pmc A
    A = new 'NumMatrix2D'
    $I0 = rows + 1
    $I1 = cols + 1
    A[$I0;$I1] = 1.0
    A.'fill'(1.0)
    .return(A)
.end


