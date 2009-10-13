.namespace ["_Matrixy";"builtins"]

=item disp(PMC msg)

prints a single string or value to the terminal. Eventually,
this function will be able to print all the entries in a
row matrix as well.

=cut

.sub 'disp'
    .param int nargout
    .param int nargin
    .param pmc msg
    $S0 = '!get_matrix_string'(msg)
    say $S0
    .return()
.end
