=item exist(name)

Returns 1 if name exists otherwise returns 0.

This eventually will be extended to determine the type of name.

=cut

.namespace ["_Matrixy";"builtins"]

.sub 'exist'
    .param int nargout
    .param int nargin
    .param string name

    $P0 = '!lookup_function'(name)
    unless null $P0 goto found_name
    .return(0)

    found_name:
        .return(1)
.end

