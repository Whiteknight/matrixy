=head1 DESCRIPTION

This is a temporary function for generating Complex numbers
from strings. Until PCT tools can handle this properly.

=cut

.namespace []

.sub '!generate_complex'
    .param string val
    $P0 = new 'Complex'
    $P0 = val
    .return ($P0)
.end

