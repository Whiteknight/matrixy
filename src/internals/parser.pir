.namespace []

.sub '_terminator_has_semicolon'
    .param string term
    $S0 = substr term, 0, 1
    if $S0 == ';' goto has_semicolon
    .return(0)
  has_semicolon:
    .return(1)
.end

.sub '!_final_exception_handler'
    .param pmc ex
    $I0 = ex["severity"]
    if $I0 >= 6 goto really_exit
    $S0 = ex["message"]
    print "error: "
    say $S0
    # TODO: Print backtrace here
    .return()

  really_exit:
    exit 0
.end
