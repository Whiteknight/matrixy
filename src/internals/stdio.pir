=head1 NAME

F<src/builtins/stdio.pir> - built-in stdio functions

=head1 DESCRIPTION

This file contains some of the basic functions for I/O on
the console and in files.

=head1 Functions

=over 4

=cut

.namespace []

=item _disp_all(PMC args :slurpy)

This is similar to the disp() function above, accept that
it prints out a slurpy list of arguments to the terminal.

This is non-standard, so it begins with an underscore.

=cut

.sub '_disp_all'
    .param pmc args :slurpy
    # TODO: Update this to call '!get_matrix_string'
    .local pmc iter
    iter = new 'Iterator', args
  iter_loop:
    unless iter goto iter_end
    $S0 = shift iter
    print $S0
    goto iter_loop
  iter_end:
    print "\n"
    .return (1)
.end


=item _error_all(PMC args :slurpy)

raises an exception with the message which is given
piecewise. The arguments are stringified and concatinated,
and the resulting message is used to raise an exception.

=cut

.sub '_error_all'
    .param pmc args :slurpy
    .local pmc iter
    # TODO: Update this to call '!get_matrix_string'
    iter = new 'Iterator', args
    $S0 = ''
  iter_loop:
    unless iter goto iter_end
    $S1 = shift iter
    $S0 = $S0 . $S1
    goto iter_loop
  iter_end:
    $P1 = new 'Exception'
    $P1['message'] = $S0
    throw  $P1
    .return()
.end

=item _print_result_a(PMC name, PMC value, STRING term)

Handles the MATLAB/Octave behavior where the value of an
assigment is printed to the terminal, unless the statement
is postfixed with a ';'. If the ';' exists, nothing is
printed. Otherwise, the name of the variable and the value
that has been assigned to it is printed.

For example, typing C<x = 5> at the prompt without a
semicolor will cause Octave to print:

    x =

        5

=item _print_result_e(PMC value, STRING term)

Handles the MATLAB/Octave behavior where the value of an
expression is printed to the terminal unless the statement
is postfixed with a ';'. If the ';' exists, nothing is
printed. Otherwise, the value of the expression is assigned
to the C<ans> variable, and it is printed to the terminal.

For example, typing C<5 + 4> at the prompt without a
semicolon will cause Octave to print

    ans =

        9

In this way, Matrixy can be used as a sort of desk calculator.

=item _print_result_a(PMC value, STRING term)

Prints the value of a bare variable or subroutine call name. So writing

  x(5)

Will print out

  ans =
  
      9

if the result of the variable x, or the subroutine call x() returns the value
"9" with argument "5".

=cut

.sub '!print_result_a'
    .param pmc name
    .param pmc value
    print name
    say " = "
    $S0 = '!get_matrix_string'(value)
    say $S0
    set_hll_global "ans", value
    .return()
.end

.sub '!print_result_e'
    .param pmc value
    $I0 = defined value
    unless $I0 goto end_print_result
    print "ans = "
    $S0 = '!get_matrix_string'(value)
    say $S0
    set_hll_global "ans", value
  end_print_result:
    .return()
.end

.sub '!store_last_ans'
    .param pmc value
    set_hll_global "ans", value
.end

=back

=cut

