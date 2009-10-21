.namespace []

.sub '_terminator_has_semicolon'
    .param string term
    $S0 = substr term, 0, 1
    if $S0 == ';' goto has_semicolon
    .return(0)
  has_semicolon:
    .return(1)
.end
