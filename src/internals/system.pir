=head1 NAME

F<src/internals/system.pir> - built-in system functions

=head1 DESCRIPTION

These functions interact with the system in some way, and
do secret system stuff.

=head1 Functions

=over 4

=cut

.namespace []

.sub '_system'
    .param pmc args :slurpy

    $P0 = get_hll_global ["_Matrixy";"builtins"], 'system'
    $P0(0, 1, args :flat)
.end

=back

=cut

