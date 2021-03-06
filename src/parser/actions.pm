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
                        "    '!_final_exception_handler'(%r)\n"
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
    our @DISPLAYVALUES;

    if $key eq "open" {
        our $NUMLVALUES;
        $NUMLVALUES := 0;
        @DISPLAYVALUES := _new_empty_array();
    }
    else {
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
            my $past := PAST::Stmts.new(
                :node($/),
                $( $<assignment> )
            );
            for @DISPLAYVALUES {
                $past.push(
                    PAST::Op.new(
                        :pasttype('inline'),
                        :node($/),
                        :inline("    '!print_result_a'(%0, %1)"),
                        PAST::Val.new(
                            :value($_),
                            :returns('String')
                        ),
                        PAST::Var.new(
                            :name($_),
                            :scope('package')
                        )
                    )
                );
            }
            make $past;
        }
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
        :name("!_system"),
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
            :name('!get_for_loop_iteration_array'),
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

=begin

Here is what we want things to look like:

  x(...) = c
  x = '!indexed_assign'(x, c, ...)

  [a(...), b(...)] = c
  $P1 = c[0]
  a = '!indexed_assign'(a, $P1, ...)
  $P2 = c[1]
  b = '!indexed_assign'(b, $P2, ...)

=cut

method assignment($/, $key) {
    our $?BLOCK;
    our %?GLOBALS;
    our $NUMLVALUES;   # number of values in current assignment
    our $ASSIGNVALUE;  # value or array of values to assign
    our $ARRAYASSIGN;  # Whether we are in array or scalar mode
    our $?LVALUECELL;  # lvalue is being indexed with {}
    our @?LVALUEPARAMS;

    if $key eq "open" {
        @?LVALUEPARAMS := _new_empty_array();
        $NUMLVALUES := 1;
        $ASSIGNVALUE := PAST::Var.new(
            :name("__tmp_assign_helper")
        );
        $ARRAYASSIGN := PAST::Val.new(
            :value(0),
            :returns('Integer')
        );
    }
    elsif $key eq "lvalues" {
        $NUMLVALUES--;
    }
    else {
        if +($<lvalue>) > 1 {
            $ARRAYASSIGN.value(1);
        }
        # $ASSIGNVALUE = <expression>
        my $region := PAST::Stmts.new(
            PAST::Op.new(
                :pasttype('bind'),
                :node($/),
                $ASSIGNVALUE,
                $($<expression>)
            )
        );
        # Now push all the items that read from $ASSIGNVALUE
        for $<lvalue> {
            $region.push( $($_) );
        }
        $NUMLVALUES := 0;
        make $region;
    }
}

method lvalue($/) {
    our $NUMLVALUES;    # number of values in current assignment
    our $ASSIGNVALUE;   # value or array of values to assign
    our $ARRAYASSIGN;   # Whether we are in array or scalar mode
    our $?LVALUECELL;   # Whether the lvalue is indexed with {}
    our %?GLOBALS;      # list of variables explicitly described as global
    our @?LVALUEPARAMS; # the indices on the lvalue
    our @DISPLAYVALUES; # values to print if the trailing ; is omitted

    my $indexer := '!indexed_assign';
    if $?LVALUECELL {
        $indexer := '!indexed_assign_cell';
        $?LVALUECELL := 0;
    }
    my $lhs := $( $<variable> );
    $lhs.lvalue(1);
    my $name := $lhs.name();
    if %?GLOBALS{$name} {
        # TODO: Make sure we want "Matrixy::globals", not ["Matrixy","globals"]
        $lhs.namespace("Matrixy::globals");
    }
    # ... = '!indexed_assign'(var, value, idx, array?, ...)
    my $idx := _integer_copy($NUMLVALUES);
    $idx--;
    my $idxnode := PAST::Val.new(
        :value($idx),
        :returns('Integer')
    );
    @DISPLAYVALUES.push($name);
    my $rhs := PAST::Op.new(
        :pasttype('call'),
        :name($indexer),
        PAST::Var.new(
            :name($name),
            :scope('package')
        ),
        $ASSIGNVALUE,
        $idxnode,
        $ARRAYASSIGN
    );
    for @?LVALUEPARAMS {
        $rhs.push($_);
    }
    $NUMLVALUES++;
    make PAST::Op.new(
        $lhs,
        $rhs,
        :pasttype('bind'),
        :name( $name ),
        :node($/)
    );
}



method lvalue_postfix_index($/, $key) {
    our @?LVALUEPARAMS;
    our $?LVALUECELL;
    if $key eq "cellexpression" {
        $?LVALUECELL := 1;
    }
    if $key eq "expressions" || $key eq "cellexpression" {
        for $<expression> {
            @?LVALUEPARAMS.push($($_));
        }
    }
    else {
        # TODO: This isn't right for structures
        my $name := $( $<identifier> ).name();
        @?LVALUEPARAMS.push(
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
    our @FUNCRETURNS;

    my $past := $( $<func_sig> );

    for $<statement> {
        $past.push($($_));
    }

    # add a return statement if needed
    if @FUNCRETURNS {
        my $retop := PAST::Op.new(
            :pasttype('return')
        );
        for @FUNCRETURNS {
            $retop.push(
                PAST::Var.new(
                    :name($_.name())
                )
            )
        }
        $past.push($retop);
    }

    # remove the block from the scope stack
    # and restore the "current" block
    @?BLOCK.shift();
    $?BLOCK := @?BLOCK[0];

    $past.control('return_pir');
    make $past;
}

method func_sig($/) {
    our $?BLOCK;
    our @?BLOCK;
    our @FUNCRETURNS;

    @FUNCRETURNS := _new_empty_array();
    my $name := $( $<identifier>[0] );
    $<identifier>.shift();

    my $past := PAST::Block.new(
        :blocktype('declaration'),
        :namespace('Matrixy', 'functions'),
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
        if $param.name() eq "varargin" {
            $hasvarargin := 1;
            $past.push(
                PAST::Op.new(
                    :pasttype('inline'),
                    :inline(
                        "    .local pmc varargin\n" ~
                        "    varargin = new ['PMCMatrix2D']\n" ~
                        "    \$I0 = elements %0\n" ~
                        "    varargin.'initialize_from_array'(1, \$I0, %0)\n" ~
                        "    .lex \"varargin\", varargin\n"
                    ),
                    PAST::Var.new(
                        :name('__varargin_raw'),
                        :scope('parameter'),
                        :slurpy(1),
                        :node($/)
                    )
                )
            );
            $past.symbol("varargin", :scope('lexical'));
        }
        else {
            ## enter the parameter as a lexical into the block's symbol table
            $param.scope('parameter');
            $past.symbol($param.name(), :scope('lexical'));
            $past.push($param);
        }
    }

    if $<return_identifier> {
        my $hasvarargout := 0;
        for $<return_identifier> {
            if $hasvarargout == 1 {
                _error_all("varargout must be the last return value")
            }
            my $param := $( $_ );
            if $param.name() eq "varargout" {
                #_disp_all("has varargout");
                $hasvarargout := 1;
            }
            else {
                #_disp_all("a normal parameter ", $param.name());
                $param.scope('lexical');
                $param.isdecl(1);
                $past.symbol($param.name(), :scope('lexical'));
                $past.push($param);
                @FUNCRETURNS.push($param);
            }
        }
        if $hasvarargout == 1 {
            # if we have the varargout return identifier, autovivify it into
            # a cell
            _disp_all("setting up varargout");
            $past.push(
                PAST::Op.new(
                    :pasttype('bind'),
                    :node($/),
                    PAST::Var.new(
                        :name("varargout"),
                        :scope("lexical"),
                        :isdecl(1),
                        :node($/)
                    ),
                    PAST::Op.new(
                        :pasttype('call'),
                        :name('!cell'),
                        :node($/)
                    )
                )
            );
            _disp_all("setting scope");
            $past.symbol("varargout", :scope("lexical"));
            _disp_all("adding retvalue");
            @FUNCRETURNS.push(
                PAST::Var.new(
                    :name("varargout"),
                    :scope("lexical"),
                    :node($/)
                )
            );
            _disp_all("done with varargout");
        }
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
    our $NUMLVALUES;

    my $invocant := $( $<primary> );
    my $name := $invocant.name();
    my $parens := 0;

    if $key eq "args" {
        $parens := 1;
    } elsif $key eq "cellargs" {
        $parens := 2;
    }
    if %?GLOBALS{$name} {
        # TODO: "Matrixy";"globals"
        $invocant.namespace("Matrixy::globals");
    }

    my $nargin := 0;
    my $nargout := 0;
    if _is_defined($NUMLVALUES) {
        $nargout := $NUMLVALUES;
    }

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
            :value($parens),
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
    make $past;
}

# A variable is exactly like a primary except we can deduce from the grammar
# that it's definitely a variable and not a function call. Few opportunities
# to do this.
method variable($/) {
    our $?BLOCK;
    my $past := $( $<identifier> );
    make $past;
}

method array_constructor($/) {
    my $past := PAST::Op.new(
        :name('!matrix_from_rows'),
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
        :name('!matrix_row'),
        :pasttype('call'),
        :node($/)
    );
    for $<expression> {
        $past.push($($_));
    }
    make $past;
}

method cell_constructor($/) {
    my $past := PAST::Op.new(
        :name('!cell_from_rows'),
        :pasttype('call'),
        :node($/)
    );
    for $<cell_row> {
        $past.push($($_));
    }
    make $past;
}

method cell_row($/) {
    my $past := PAST::Op.new(
        :name('!cell_row'),
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
    our $?MATRIXSTRING;
    $?MATRIXSTRING := 1;
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
        my $past := PAST::Op.new( :node($/) );
        if $<pasttype> {
            $past.pasttype( $<top><pasttype> );
        }
        else {
            $past.pasttype('call');
            $past.push(
                PAST::Var.new(
                    :name(~$<type>),
                    :namespace("_Matrixy","builtins")
                )
            );
        }
        for @($/) {
            $past.push( $_.ast );
        }
        make $past;
    }
}
