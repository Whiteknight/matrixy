.namespace ["_Matrixy";"builtins"]

.sub parrot_method
    .param int nargout
    .param int nargin
    .param pmc obj
    .param pmc method
    .param pmc args :slurpy

    $S0 = typeof method
    if $S0 == "String" goto have_string
    if $S0 == "CharMatrix2D" goto have_string_array
    error("method must be a string")
  have_string:
    $S0 = method
    goto have_method_str
  have_string_array:
    $S0 = method[0]
  have_method_str:
    $P1 = new ['PMCMatrix2D']
    ($P0 :slurpy) = obj.$S0(args :flat)
    if null $P0 goto just_return
    $I0 = elements $P0
    $P1.'initialize_from_array'(1, $I0, $P0)
  just_return:
    .return($P1)
.end
