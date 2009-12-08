.namespace ["_Matrixy";"builtins"]

.sub parrot_new
    .param int nargout
    .param int nargin
    .param pmc type
    .param pmc init :optional
    .param int has_init :opt_flag

    $S0 = typeof type
    if $S0 == "String" goto have_string
    if $S0 == "CharMatrix2D" goto have_string_array
    error("type must be a string")
  have_string:
    $S0 = type
    goto have_type_str
  have_string_array:
    $S0 = type[0]
  have_type_str:
    if has_init goto use_initializer
    $P0 = new [$S0]
    .return($P0)
  use_initializer:
    $P0 = new [$S0], init
    .return($P0)
.end

