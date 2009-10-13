=item rmpath(dir1 [, dir2, ...])

Removes path(s).

=cut

.sub 'rmpath'
    .param int nargout
    .param int nargin
    .param string path
    .param pmc args :slurpy

    .local pmc searchpath
    searchpath = get_hll_global ["Matrixy";"Grammar";"Actions"], "@?PATH"

    $P0 = new ['ResizablePMCArray'] # what we want to remove
    $I1 = args
    splice $P0, args, 0, $I1
    push $P0, path

    $P1 = iter $P0

    $P2 = new ['ResizablePMCArray'] # stores new searchpath


    $P3 = new 'Hash' # stores current path
    $P4 = iter searchpath
  buildhash_lp:
    unless $P4 goto check_lp
    $P5 = shift $P4
    $S0 = $P5
    set $P3[$S0], 0
    goto buildhash_lp


  check_lp:
    unless $P1 goto build_sp
    $P6 = shift $P1
    $S1 = $P6
    $I1 = exists $P3[$P6]
    if $I1 goto delete_from_hash
    goto check_lp


  delete_from_hash:
    delete $P3[$S1]
    goto check_lp


  build_sp:
    $P7 = iter $P3

  build_sp_lp:
    unless $P7 goto end
    $S2 = shift $P7
    say $S1
    push $P2, $S2
    goto build_sp_lp

  end:
    set_hll_global ["Matrixy";"Grammar";"Actions"], "@?PATH", $P2

    .return()
.end

