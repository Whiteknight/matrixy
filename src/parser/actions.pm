# $Id$

=head1 Comments

Matrixy::Grammar::Actions - ast transformations for Matrixy

This file contains the methods that are used by the parse grammar
to build the PAST representation of an Matrixy program.
Each method below corresponds to a rule in F<src/parser/grammar.pg>,
and is invoked at the point where C<{*}> appears in the rule,
with the current match object as the first argument.  If the
line containing C<{*}> also has a C<#= key> comment, then the
value of the comment is passed as the second argument to the method.

=cut

class Matrixy::Grammar::Actions;

# TODO: I had heard that the stuf about @?BLOCK and manually handling scopes
#       is not necessary anymore with the recent versions of PCT. If this is
#       the case, update this.
method TOP($/, $key) {
    our @?BLOCK;
    our $?BLOCK;

    if $key eq 'open' {
        ## create the top-level block here; any top-level variable
        ## declarations are entered into this block's symbol table.
        ## Note that TOP *must* deliver a PAST::Block with blocktype
        ## "declaration".
        $?BLOCK := PAST::Block.new( :blocktype('declaration'), :node($/) );
        $?BLOCK.symbol_defaults( :scope('package') );
        @?BLOCK.unshift($?BLOCK);
    }
    else {
        ## retrieve the block created in the "if" section in this method.
        my $past := PAST::Stmts.new();
        for $<stat_or_def> {
            $past.push($($_));
        }
        my $block := @?BLOCK.shift();
        $block.unshift(
            PAST::Op.new(
                :pasttype('try'),
                :node($/),
                $past,
                PAST::Op.new(
                    :pasttype('inline'),
                    :inline(
                        "    .get_results(%r)\n" ~
                        "    .local string msg\n" ~
                        "    msg = %r['message']\n" ~
                        "    print 'error: '\n" ~
                        "    say msg\n"
                    )
                )
            )
        );
        make $block;
    }
}

method stat_or_def($/, $key) {
    make $( $/{$key} );
}

method statement($/, $key) {
    make $( $/{$key} );
}

method function_handle($/) {
    my $past := $( $<identifier>  );
    my $name := $past.name();
    make PAST::Op.new(
        :pasttype('call'),
        :name('!lookup_function'),
        PAST::Val.new(
            :value($name),
            :returns('String')
        )
    );
}

method terminator($/) {
    our $?TERMINATOR;
    $?TERMINATOR := _terminator_has_semicolon(~$/);
}

method stmt_with_value($/, $key) {
    our $?TERMINATOR;
    if $?TERMINATOR == 1 {
        make PAST::Op.new(:pasttype('inline'), :node($/),
            :inline("    '!store_last_ans'(%0)"),
            $( $/{$key} )
        );
    }
    elsif $key eq "expression" {
        make PAST::Op.new(:pasttype('inline'), :node($/),
            :inline("    '!print_result_e'(%0)"),
            $( $<expression> )
        )
    }
    elsif $key eq "assignment" {
        my $assignment := $( $<assignment> );
        my $past := PAST::Stmts.new( :node($/),
            PAST::Op.new( :pasttype('inline'), :node($/),
                :inline("    '!print_result_a'(%0, %1)"),
                PAST::Val.new( :value( $assignment.name() ), :returns('String')),
                $assignment
            )
        );
        make $past;
    }
}

method global_statement($/) {
    my $past := $( $<identifier> );
    my $name := $past.name();
    $past.scope("package");
    our %?GLOBALS;
    if %?GLOBALS{$name} {
        make PAST::Stmts.new();
    } else {
        $past.isdecl(1);
        $past.namespace("Matrixy::globals");
        %?GLOBALS{$name} := 1;
        make $past;
    }
}

method control_statement($/, $key) {
    make $( $/{$key} );
}

method system_call($/) {
    make PAST::Op.new(
        :name("_system"),
        :pasttype('call'),
        :node($/),
        PAST::Val.new(
            :value( ~$<sys_bare_words> ),
            :returns('String'),
            :node($/)
        )
    );
}

method if_statement($/) {
    my $cond := $( $<expression> );
    my $then := $( $<statement_list> );
    my $past := PAST::Op.new( $cond, $then, :pasttype('if'), :node($/) );

    ## if there's an else clause, add it to the PAST node.
    if $<else> {
        $past.push( $( $<else>[0] ) );
    }
    make $past;
}

method while_statement($/) {
    my $cond := $( $<expression> );
    my $body := $( $<statement_list> );
    make PAST::Op.new( $cond, $body, :pasttype('while'), :node($/) );
}

method for_statement($/) {
    our $?BLOCK;
    our @?BLOCK;

    # Create a new block for the loop body
    my $body :=  PAST::Block.new( :blocktype('immediate'), :node($/) );
    $?BLOCK := $body;
    @?BLOCK.unshift($?BLOCK);

    my $var := $( $<identifier> );
    $var.isdecl(1);
    $var.scope('parameter');
    $body.symbol($var.name(), :scope('lexical'));
    $body.push($var);

    $body.push($($<statement_list>));

    @?BLOCK.shift();
    $?BLOCK := @?BLOCK[0];
    make PAST::Op.new(
        :pasttype('for'),
        :node($/),
        PAST::Op.new(
            :pasttype('call'),
            :name('!get_first_array_row'),
            $( $<array_or_range> )
        ),
        $body
    );
}

method array_or_range($/, $key) {
    make $( $/{$key} );
}

method try_statement($/) {
    make PAST::Op.new(
        :pasttype('try'),
        :node($/),
        $( $<try> ),
        PAST::Stmts.new(
            PAST::Op.new(
                :pasttype('inline'),
                :inline(
                    "    .get_results (%r)\n" ~
                    "    set_hll_global ['Matrixy';'Grammar';'Actions'], '$?LASTERR', %r"
                )
            ),
            $( $<catch> )
        )
    );
}

# TODO: See the comment for "TOP" above. The $?BLOCK stuff might need to
#       Disappear.
method block($/, $key) {
    our $?BLOCK; ## the current block
    our @?BLOCK; ## the scope stack

    if $key eq 'open' {
        $?BLOCK := PAST::Block.new( :blocktype('immediate'), :node($/) );
        @?BLOCK.unshift($?BLOCK);
    }
    else {
        ## retrieve the current block, remove it from the scope stack
        ## and restore the "current" block.
        my $past := @?BLOCK.shift();
        $?BLOCK  := @?BLOCK[0];

        for $<statement> {
            $past.push($($_));
        }
        make $past
    }
}

method statement_list($/) {
    my $past := PAST::Stmts.new(:node($/));
    for $<statement> {
        $past.push($($_));
    }
    make $past;
}

# TODO: I don't think return statements take values, because the function's
#       return values are specified in the subroutine definition. Fix this.
method return_statement($/) {
    my $expr := $( $<expression> );
    my $past := PAST::Op.new( $expr, :pasttype('return'), :node($/) );
    make $past
}

method do_block($/) {
    make $( $<block> );
}

# We're turning this:
#     x(a, b) = c
# into this:
#     x = '!indexed_assign'(x, c, a, b)
# We have to do this because of the way that indices are managed in M, and how
# matrices can be indexed like vectors.
method assignment($/, $key) {
    our $?BLOCK;
    our %?GLOBALS;
    our @?PARAMS;
    if $key eq "open" {
        @?PARAMS := _new_empty_array();
    }
    else {
        my $rhs := $( $<expression> );
        my $lhs := $( $<variable> );
        $lhs.lvalue(1);
        my $name := $lhs.name();
        if %?GLOBALS{$name} {
            $lhs.namespace("Matrixy::globals");
        }
        $rhs := PAST::Op.new(
            :pasttype('call'),
            :name('!indexed_assign'),
            PAST::Var.new(
                :name($lhs.name()),
                :scope('package')
            ),
            $rhs
        );
        for @?PARAMS {
            $rhs.push($_);
        }
        make PAST::Op.new(
            $lhs,
            $rhs,
            :pasttype('bind'),
            :name( $lhs.name() ),
            :node($/)
        );
    }
}

method lvalue_postfix_index($/, $key) {
    our @?PARAMS;
    if $key eq "expressions" {
        for $<expression> {
            @?PARAMS.push($($_));
        }
    }
    else {
        my $name := $( $<identifier> ).name();
        @?PARAMS.push(
            PAST::Val.new(
                :value($name),
                :returns('String')
            )
        );
    }
    make PAST::Stmts.new();
}

method variable_declaration($/) {
    our $?BLOCK;

    my $past := $( $<identifier> );
    $past.isdecl(1);
    $past.scope('lexical');

    ## if there's an initialization value, use it to viviself the variable.
    if $<expression> {
        $past.viviself( $( $<expression>[0] ) );
    }
    else { ## otherwise initialize to undef.
        $past.viviself( 'Undef' );
    }

    ## cache this identifier's name
    my $name := $past.name();

    ## if the symbol is already declared, emit an error. Otherwise,
    ## enter it into the current block's symbol table.
    if $?BLOCK.symbol($name) {
        $/.panic("Error: symbol " ~ $name ~ " was already defined\n");
    }
    else {
        $?BLOCK.symbol($name, :scope('lexical'));
    }
    make $past;
}


method func_def($/) {
    our @?BLOCK;
    our $?BLOCK;

    our @RETID;

    my $past := $( $<func_sig> );

    if $?BLOCK.symbol("varargin") {
        $past.push(
            PAST::Op.new(
                :pasttype('bind'),
                PAST::Var.new(
                    :name('varargin'),
                    :scope('lexical'),
                    :lvalue(1)
                ),
                PAST::Op.new(
                    :pasttype('call'),
                    :name('!array_col'),
                    PAST::Var.new(
                        :name('varargin'),
                        :scope('lexical')
                    )
                )
            )
        );
    }
    for $<statement> {
        $past.push($($_));
    }

    # add a return statement if needed
    #
    if @RETID {
        my $var := PAST::Var.new(
            :name(@RETID[0].name())
        );
        my $retop := PAST::Op.new( $var, :pasttype('return') );
        $past.push($retop);
        @RETID.shift();
    }

    ## remove the block from the scope stack
    ## and restore the "current" block
    @?BLOCK.shift();
    $?BLOCK := @?BLOCK[0];

    $past.control('return_pir');
    make $past;
}

method func_sig($/) {
    our $?BLOCK;
    our @?BLOCK;
    our @RETID;

    my $name := $( $<identifier>[0] );
    $<identifier>.shift();

    my $past := PAST::Block.new(
        :blocktype('declaration'),
        :namespace('Matrixy::functions'),
        :node($/),
        :name($name.name()),
        PAST::Var.new(
            :name('nargout'),
            :scope('parameter'),
            :node($/)
        ),
        PAST::Var.new(
            :name('nargin'),
            :scope('parameter'),
            :node($/)
        )
    );
    $past.symbol("nargout", :scope('lexical'));
    $past.symbol("nargin", :scope('lexical'));

    my $hasvarargin := 0;
    for $<identifier> {
        if $hasvarargin {
            $/.panic('varargin must be the last parameter');
        }
        my $param := $( $_ );
        $param.scope('parameter');
        if $param.name() eq "varargin" {
            $hasvarargin := 1;
            $param.slurpy(1);
        }
        $past.push($param);

        ## enter the parameter as a lexical into the block's symbol table
        $past.symbol($param.name(), :scope('lexical'));
    }

    if $<return_identifier> {
        my $param := $( $<return_identifier>[0] );
        $param.scope('lexical');
        $param.isdecl(1);
        $past.push($param);
        $past.symbol($param.name(), :scope('lexical'));
        @RETID[0] := $param;
    }

    ## set this block as the current block, and store it on the scope stack
    $?BLOCK := $past;
    @?BLOCK.unshift($past);

    make $past;
}

method return_identifier($/) {
    my $name  := ~$/;
    ## instead of ~$/, you can also write ~$<ident>, as an identifier
    ## uses the built-in <ident> rule to match identifiers.
    make PAST::Var.new( :name($name), :node($/) );
}

method anon_func_constructor($/) {
    my $block := PAST::Block.new( :blocktype('declaration'), :node($/) );

    $block.push(
        PAST::Var.new(
            :name('nargout'),
            :scope('parameter'),
            :node($/)
        )
    );
    $block.symbol("nargout", :scope('lexical'));
    $block.push(
        PAST::Var.new(
            :name('nargin'),
            :scope('parameter'),
            :node($/)
        )
    );
    $block.symbol("nargin", :scope('lexical'));
    for $<identifier> {
        my $param := $( $_ );
        $param.scope('parameter');
        $block.push($param);

        ## enter the parameter as a lexical into the block's symbol table
        $block.symbol($param.name(), :scope('lexical'));
    }

    my $var := PAST::Var.new(:node($/) );
    # $var.lvalue(1);

    my $op := PAST::Op.new(
        $var,
        $($<expression>),
        :pasttype('bind'),
        :node($/)
    );
    $block.push($op);

    my $retop := PAST::Op.new( $var, :pasttype('return') );
    $block.push($retop);

    $block.control('return_pir');
    make $block;
}

# TODO: This all isn't very clean right now. I think we can refactor this to
#       be a little cleaner/better
method sub_or_var($/, $key) {
    our @?BLOCK;
    our %?GLOBALS;
    my $invocant := $( $<primary> );
    my $name := $invocant.name();
    if %?GLOBALS{$name} {
        $invocant.namespace("Matrixy::globals");
    }
    my $nargin := 0;
    my $nargout := 0;
    my $past := PAST::Op.new(
        :name('!dispatch'),
        :pasttype('call'),
        :node($/)
    );
    if $<expression> {
        for $<expression> {
            $past.push($($_));
            $nargin++;
        }
    }
    $past.unshift(
        PAST::Val.new(
            :value($key eq "args"),
            :returns('Integer')
        )
    );
    $past.unshift(
        PAST::Val.new(
            :value($nargin),
            :returns('Integer')
        )
    );
    $past.unshift(
        PAST::Val.new(
            :value($nargout),
            :returns('Integer')
        ),
    );
    $past.unshift($invocant);
    $past.unshift(
        PAST::Val.new(
            :value($invocant.name()),
            :returns('String'),
            :node($/)
        )
    );
    make $past;
}

method bare_words($/) {
    my $content := ~$/;
    make PAST::Val.new(
        :value($content),
        :node($/)
    );
}

method primary($/) {
    my $past := $( $<identifier> );
    for $<postfix_expression> {
        my $expr := $( $_ );
        ## set the current $past as the first child of $expr;
        ## $expr is either a key or an index; both are "keyed"
        ## variable access, where the first child is assumed
        ## to be the aggregate.
        $expr.unshift($past);
        $past := $expr;
    }
    make $past;
}

# A variable is exactly like a primary except we can deduce from the grammar
# that it's definitely a variable and not a function call. Few opportunities
# to do this.
method variable($/) {
    our $?BLOCK;
    my $past := $( $<identifier> );
    my $name := $past.name();
    for $<postfix_expression> {
        my $expr := $( $_ );
        $expr.unshift($past);
        $past := $expr;
    }
    make $past;
}

method postfix_expression($/, $key) {
    make $( $/{$key} );
}

method key($/) {
    my $key := $( $<expression> );

    make PAST::Var.new(
        $key,
        :scope('keyed'),
        :vivibase('Hash'),
        :viviself('Undef'),
        :node($/)
    );
}

method member($/) {
    my $member := $( $<identifier> );
    ## x.y is syntactic sugar for x{"y"}, so stringify the identifier:
    my $key := PAST::Val.new(
        :returns('String'),
        :value($member.name()),
        :node($/)
    );

    ## the rest of this method is the same as method key() above.
    make PAST::Var.new(
        $key,
        :scope('keyed'),
        :vivibase('Hash'),
        :viviself('Undef'),
        :node($/)
    );
}

method index($/) {
    my $index := $( $<expression> );

    make PAST::Var.new(
        $index,
        :scope('keyed'),
        :vivibase('ResizablePMCArray'),
        :viviself('Undef'),
        :node($/)
    );
}

method named_field($/) {
    my $past := $( $<expression> );
    my $name := $( $<string_constant> );
    ## the passed expression is in fact a named argument,
    ## use the named() accessor to set that name.
    $past.named($name);
    make $past;
}

method array_constructor($/) {
    # Create an array of array_rows, which are going to be arrays themselves.
    # All matrices are going to be two dimensional, sometimes that just won't
    # be obvious.
    my $past := PAST::Op.new(
        :name('!array_col'),
        :pasttype('call'),
        :node($/)
    );
    for $<array_row> {
        $past.push($($_));
    }
    make $past;
}

method array_row($/) {
    my $past := PAST::Op.new(
        :name('!array_row'),
        :pasttype('call'),
        :node($/)
    );
    for $<expression> {
        $past.push($($_));
    }
    make $past;
}

method range_constructor($/, $key) {
    my $past := PAST::Op.new(
        :name('!range_constructor_' ~ $key),
        :pasttype('call'),
        :node($/)
    );
    for $<subexpression> {
        $past.push($($_));
    }
    make $past;
}

method subexpression($/, $key) {
    make $( $/{$key} );
}

method hash_constructor($/) {
    ## use the parrot calling conventions to
    ## create a hash, using the "anonymous" sub
    ## !hash (which is not a valid Squaak name)
    my $past := PAST::Op.new(
        :name('!hash'),
        :pasttype('call'),
        :node($/)
    );
    for $<named_field> {
        $past.push($($_));
    }
    make $past;
}

method term($/, $key) {
    make $( $/{$key} );
}

method identifier($/) {
    my $name  := ~$/;
    ## instead of ~$/, you can also write ~$<ident>, as an identifier
    ## uses the built-in <ident> rule to match identifiers.
    make PAST::Var.new( :name($name), :node($/) );
}

method integer_constant($/) {
    make PAST::Val.new( :value( ~$/ ), :returns('Integer'), :node($/) );
}

method float_constant($/) {
    make PAST::Val.new( :value( ~$/ ), :returns('Float'), :node($/) );
}

method complex_constant($/) {

    my $past := PAST::Op.new(
        :name('!generate_complex'),
        :pasttype('call'),
        :node($/)
    );
    $past.unshift(
        PAST::Val.new(
            :value(~$/),
            :returns('String')
        )
    );
    make $past;

    #make PAST::Val.new( :value( ~$/ ), :returns('Complex'), :node($/) );
}

method string_constant($/) {
    make PAST::Val.new(
        :value( $($<string_literal>) ),
        :returns('String'),
        :node($/)
    );
}

## Handle the operator precedence table.
method expression($/, $key) {
    if ($key eq 'end') {
        make $($<expr>);
    }
    else {
        my $past := PAST::Op.new(
            :name($<type>),
            :pasttype($<top><pasttype>),
            :pirop($<top><pirop>),
            :lvalue($<top><lvalue>),
            :node($/)
        );
        for @($/) {
            $past.push( $($_) );
        }
        make $past;
    }
}
