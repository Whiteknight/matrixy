.namespace []

=head1 Matrix-Aware Operators

These operators properly act on matrix arguments.

=cut

.sub 'infix:=='
    .param pmc a
    .param pmc b
    $S0 = typeof a
    if $S0 == 'ResizablePMCArray' goto compare_matrices
    $S1 = typeof b
    if $S1 == 'ResizablePMCArray' goto compare_matrices
    iseq $I0, a, b
    .return ($I0)
  compare_matrices:
    $P0 = get_hll_global ['_Matrixy';'builtins'], 'isequal'
    $I0 = $P0(1, 2, a, b)
    .return ($I0)
.end

.sub 'infix:!='
    .param pmc a
    .param pmc b
    $S0 = typeof a
    if $S0 == 'ResizablePMCArray' goto compare_matrices
    $S1 = typeof b
    if $S1 == 'ResizablePMCArray' goto compare_matrices
    isne $I0, a, b
    .return ($I0)
  compare_matrices:
    $P0 = get_hll_global ['_Matrixy';'builtins'], 'isequal'
    $I0 = $P0(1, 2, a, b)
    $I0 = not $I0
    .return($I0)
.end


# we cannot define these in terms of 
# builtin M files since it would create
# circular reference to the same operators.
.sub 'infix:+'
    .param pmc a
    .param pmc b

    $P2 = find_name "__infix:+_helper"
    $P3 = '!lookup_function'('arrayfun')
    $P4 = $P3(1,1,$P2,a,b)
    .return($P4)
.end

.sub '__infix:+_helper'
    .param int nargout
    .param int nargin
    .param pmc a
    .param pmc b
    $P0 = add a, b
    .return($P0)
.end

.sub 'infix:-'
    .param pmc a
    .param pmc b

    $P2 = find_name "__infix:-_helper"
    $P3 = '!lookup_function'('arrayfun')
    $P4 = $P3(1,1,$P2,a,b)
    .return($P4)
.end

.sub '__infix:-_helper'
    .param int nargout
    .param int nargin
    .param pmc a
    .param pmc b
    $P0 = sub a, b
    .return($P0)
.end

.sub 'infix:.^'
    .param pmc a
    .param pmc b

    $P0 = '!lookup_function'('power')
    $P1 = $P0(1,1,a,b)
    .return($P1)
.end


.sub 'infix:.*'
    .param pmc a
    .param pmc b

    $P0 = '!lookup_function'('times')
    $P1 = $P0(1,1,a,b)
    .return($P1)
.end

.sub 'infix:./'
    .param pmc a
    .param pmc b

    $P0 = '!lookup_function'('rdivide')
    $P1 = $P0(1,1,a,b)
    .return($P1)
.end


.sub 'infix:.\'
    .param pmc a
    .param pmc b

    $P0 = '!lookup_function'('ldivide')
    $P1 = $P0(1,1,a,b)
    .return($P1)
.end

.sub "postfix:'"
    .param pmc a

    $P0 = '!lookup_function'('ctranspose')
    $P1 = $P0(1,1,a)
    .return($P1)
.end

.sub "postfix:.'"
    .param pmc a

    $P0 = '!lookup_function'('transpose')
    $P1 = $P0(1,1,a)
    .return($P1)
.end

.sub 'infix:*'
    .param pmc a
    .param pmc b

    $S0 = typeof a
    if $S0 == 'ResizablePMCArray' goto do_mtimes
    $S1 = typeof b
    if $S1 == 'ResizablePMCArray' goto do_mtimes

    # since we override '*' in M world
    $P1 = a * b
    .return ($P1)

  do_mtimes:
    $P0 = '!lookup_function'('mtimes')
    $P1 = $P0(1,1,a,b)
    .return($P1)
.end

=head1 Matrix-Unaware Operators

TOD0: These all need to be fixed!

=cut

# TODO: link to mtimes as soon as
#    it can handle scalar args

.sub 'infix:^'
    .param pmc a
    .param pmc b
    $P0 = pow a, b
    .return($P0)
.end

.sub 'infix:/'
    .param pmc a
    .param pmc b
    $P0 = a / b
    .return($P0)
.end

.sub 'prefix:-'
    .param pmc a
    $P0 = neg a
    .return($P0)
.end

.sub 'infix:<'
    .param pmc a
    .param pmc b
    islt $I0, a, b
    .return ($I0)
.end


.sub 'infix:<='
    .param pmc a
    .param pmc b
    isle $I0, a, b
    .return ($I0)
.end

.sub 'infix:>'
    .param pmc a
    .param pmc b
    isgt $I0, a, b
    .return ($I0)
.end

.sub 'infix:>='
    .param pmc a
    .param pmc b
    isge $I0, a, b
    .return ($I0)
.end
