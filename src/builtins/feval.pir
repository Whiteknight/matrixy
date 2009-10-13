=item feval(STRING name, PMC args :slurpy)

Calls the function with name C<name> and arguments C<args>.

If the function isn't loaded yet, it should be looked up. Does
not currently perform any lookups however.

=cut

.namespace ["_Matrixy";"builtins"]

.sub 'feval'
    .param int nargout
    .param int nargin
    .param pmc func
    .param pmc args :slurpy

    $S0 = typeof func
    if $S0 == 'Sub' goto sub_handle
    $S0 = '!get_first_string'(func)
    $P0 = null
    .tailcall '!dispatch'($S0, $P0, nargout, nargin, 1, args :flat)

  sub_handle:
    .tailcall func(nargout, nargin, args :flat)
.end
