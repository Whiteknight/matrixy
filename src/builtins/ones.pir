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
    A.'fill'(1.0, cols, rows)
    .return(A)
.end


