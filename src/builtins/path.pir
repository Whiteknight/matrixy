=head1 NAME

F<src/builtins/path.pir> - built-in path functions

=head1 DESCRIPTION

These functions are for manipulating search path.

=head1 Functions

=over 4

=cut

.namespace ["_Matrixy";"builtins"]

=item path([<path string>])

Returns path or sets path by splitting on ';'. (TODO use pathsep)

=cut

.sub 'path'
    .param int nargout
    .param int nargin
    .param string pathlist :optional
    .param int has_pathlist :opt_flag

    unless has_pathlist goto end

    $P1 = new ['ResizablePMCArray'] # stores new searchpath
    $P1 = split ';', pathlist
    set_hll_global ["Matrixy";"Grammar";"Actions"], "@?PATH", $P1

  end:
    .local pmc searchpath
    searchpath = get_hll_global ["Matrixy";"Grammar";"Actions"], "@?PATH"
    $S1 = join ';', searchpath

    .return($S1)

.end

