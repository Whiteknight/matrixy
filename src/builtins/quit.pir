.sub 'quit'
    .param int nargout
    .param int nargin
    .param string mode :optional
    .param int has_mode :opt_flag

    if has_mode goto check_mode
    goto finish_and_die

  check_mode:
    if mode == "force" goto just_die_already
    # TODO: in finish.m, if we call "quit('cancel')" we should stop the exit
    #       and continue execution from the point after this quit call
  finish_and_die:
    # TODO: Should look for and execute finish.m if it exists
  just_die_already:
    die 5, 0
.end
