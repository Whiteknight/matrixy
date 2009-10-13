
.namespace ["_Matrixy";"builtins"]

=item system

This function handles the MATLAB/Octave behavior where
prefixing a line with '!' passes that entire line to the
system shell. For instance, on a Windows machine, typing:

  !echo hello

Will cause the word "hello" to be printed to the terminal.

=cut

.sub 'system'
    .param int nargout
    .param int nargin
    .param pmc cmd
    .param pmc flags :optional
    .param int has_flags :opt_flag
    if has_flags goto capture_output

    $S0 = '!get_first_string'(cmd)
    $I0 = spawnw $S0
    .return($I0)

  capture_output:
    'error'("Function 'system' does not support capturing output")
.end

=back

=cut

