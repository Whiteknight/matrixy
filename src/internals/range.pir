
=head1 ABOUT

Functions for building ranges using x:z or x:y:z syntax

=over 4

=item !range_constructor_two

Construct an array from a range of the form a:b

=item !range_constructor_three

Construct an array from a range of the form a:b:c

=cut

.sub '!range_constructor_two'
    .param pmc start
    .param pmc stop
    $N0 = start
    $N1 = stop
    if $N0 < $N1 goto positive_range
    if $N0 > $N1 goto negative_range
    .return(start)
  positive_range:
    .tailcall '!range_constructor_three'(start, 1, stop)
  negative_range:
    .tailcall '!range_constructor_three'(start, -1, stop)
.end

.sub '!range_constructor_three'
    .param pmc start
    .param pmc step
    .param pmc stop
    $N0 = start
    $N1 = step
    $N2 = stop
    if $N0 < $N2 goto expect_positive_step
    if $N0 > $N2 goto expect_negative_step
    .return(start)
  expect_positive_step:
    if $N1 <= 0 goto bad_step
    .tailcall '!range_constructor_positive'(start, step, stop)
  expect_negative_step:
    if $N1 >= 0 goto bad_step
    .tailcall '!range_constructor_negative'(start, step, stop)
  bad_step:
    _error_all("Step parameter is incorrect")
.end

# Actually construct the array. We know a few things right now: start and
# stop are not equal. Start, stop, and step are all properly aligned so that
# we won't loop infinitely looking for a value that we can't get.
.sub '!range_constructor_positive'
    .param pmc start
    .param pmc step
    .param pmc stop
    .local pmc newarray
    newarray = new 'ResizablePMCArray'
    $N0 = start
    $N1 = step
    $N2 = stop
  loop_top:
    push newarray, $N0
    $N0 = $N0 + $N1
    if $N0 > $N2 goto loop_end
    goto loop_top
  loop_end:
    $I0 = elements newarray
    $P0 = new ['NumMatrix2D']
    $P0.'initialize_from_array'(1, $I0, newarray)
    .return($P0)
.end

.sub '!range_constructor_negative'
    .param pmc start
    .param pmc step
    .param pmc stop
    .local pmc newarray
    newarray = new 'ResizablePMCArray'
    $N0 = start
    $N1 = step
    $N2 = stop
  loop_top:
    push newarray, $N0
    $N0 = $N0 + $N1
    if $N0 < $N2 goto loop_end
    goto loop_top
  loop_end:
    $I0 = elements newarray
    $P0 = new ['NumMatrix2D']
    $P0.'initialize_from_array'(1, $I0, newarray)
    .return($P0)
.end

=back
