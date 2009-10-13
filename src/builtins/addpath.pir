=item addpath(dir1 [, dir2, dir3, ..])

Adds path. For now only handles a single path.

=cut

.sub 'addpath'
    .param int nargout
    .param int nargin
    .param string path
    .param pmc args :slurpy

    .local pmc searchpath
    searchpath = get_hll_global ["Matrixy";"Grammar";"Actions"], "@?PATH"
    push searchpath, path

    $P0 = iter args
  loop:
    unless $P0 goto end
    $P1 = shift $P0
    $S0 = $P1
    push searchpath, $S0
    goto loop

  end:
    .return()
.end

