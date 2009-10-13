=item pir

Executes a subroutine in PIR from M code

=cut

.sub 'pir'
    .param int nargout
    .param int nargin
    .param string code
    .param pmc args :slurpy
    $P0 = compreg 'PIR'
    $P1 = $P0(code)
    $P2 = $P1(args :flat)
    .return($P2)
.end
