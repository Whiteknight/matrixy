.namespace ["_Matrixy";"builtins"]

.sub 'help'
    .param int nargout
    .param int nargin
    .param string name :optional
    .param int has_name :opt_flag

    unless has_name goto _print_basic_documentation

    .local pmc filehandle
    .local int indocs
    indocs = 0
    $P0 = get_hll_global '!find_file_in_path'
    filehandle = $P0(name)
    $I0 = defined $P0
    unless $I0 goto _get_out

  _loop_top:
    unless filehandle goto _get_out
    $S0 = readline filehandle
    $S1 = substr $S0, 0, 2
    if $S1 == "%%" goto _have_comment
    if indocs != 0 goto _loop_end
    goto _loop_top

  _have_comment:
    $S2 = substr $S0, 2
    print " - "
    print $S2
    goto _loop_top

  _loop_end:
    close filehandle
  _get_out:
    .return()

  _print_basic_documentation:
    say "Matrixy, a Parrot-based compiler for M script."
    say "Type help('<NAME>') to get help about function <NAME>"
    .return()
.end

.namespace []
