=head1 TITLE

matrixy.pir - A Matrixy compiler.

=head2 Description

This is the base file for the Matrixy compiler. Matrixy
is intended to be a clone of MATLAB/Octave for Parrot. See
F<README.POD> for more information about this language.

This file includes the parsing and grammar rules from
the src/ directory, loads the relevant PGE libraries,
and registers the compiler under the name 'Matrixy'.

=head2 Functions

=over 4

=item onload()

Creates the Matrixy compiler using a C<PCT::HLLCompiler>
object.

=cut

#.HLL 'matrixy'

.namespace [ 'Matrixy';'Compiler' ]

.sub 'onload' :anon :load :init
    load_bytecode 'PCT.pbc'

    $P0 = get_hll_global ['PCT'], 'HLLCompiler'
    $P1 = $P0.'new'()
    $P1.'language'('matrixy')
    $P0 = get_hll_namespace ['Matrixy';'Grammar']
    $P1.'parsegrammar'($P0)
    $P0 = get_hll_namespace ['Matrixy';'Grammar';'Actions']
    $P1.'parseactions'($P0)

    $P1.'commandline_prompt'("\nmatrixy:1> ")
    $P1.'commandline_banner'("Matrixy, version 0.1.\nCopyright (C) 2009 Blair Sutton and Andrew Whitworth.\n\n")
.end

=item main(args :slurpy)  :main

Start compilation by passing any command line C<args>
to the Matrixy compiler.

=cut

.sub 'main' :main
    .param pmc args

    $P0 = compreg 'matrixy'
    $P1 = $P0.'command_line'(args)
.end

.include 'src/gen_internals.pir'
.include 'src/gen_builtins.pir'
.include 'src/gen_grammar.pir'
.include 'src/gen_actions.pir'

.namespace []

.sub 'initglobals' :anon :load :init
    $P0 = new 'ResizablePMCArray'
    set_hll_global ['Matrixy';'Grammar';'Actions'], '@?BLOCK', $P0
    $P0 = new 'Undef'
    set_hll_global ['Matrixy';'Grammar';'Actions'], '$?BLOCK', $P0

    $P1 = new 'Hash'
    set_hll_global ['Matrixy';'Grammar';'Actions'], '%?FUNCTIONS', $P1

    # default path is set to current directory
    $P2 = new 'ResizablePMCArray'
    $P2[0] = "."
    $P2[1] = "toolbox/"
    set_hll_global ['Matrixy';'Grammar';'Actions'], '@?PATH', $P2

    $P3 = new 'Hash'
    set_hll_global ['Matrixy';'Grammar';'Actions'], '%?GLOBALS', $P3

    $P0 = new 'ResizablePMCArray'
    set_hll_global['Matrixy';'Grammar';'Actions'], '@?PARAMS', $P0

    # load start up file
    $P0 = null
    '!dispatch'('matrixyrc', $P0, 1, 1, 1)
.end

.namespace []

.sub '!hash'
    .param pmc fields :slurpy :named
    .return (fields)
.end

.sub '_new_empty_array'
    $P0 = new 'ResizablePMCArray'
    .return($P0)
.end

# TODO: Move this to somewhere in src/internals/*
.sub '_terminator_has_semicolon'
    .param string term
    $S0 = substr term, 0, 1
    if $S0 == ';' goto has_semicolon
    .return(0)
  has_semicolon:
    .return(1)
.end

.sub '!get_first_array_row'
    .param pmc m
    $S0 = typeof m
    if $S0 == 'ResizablePMCArray' goto have_matrix
    .return(m)
  have_matrix:
    $P0 = m[0]
    .return($P0)
.end

=back

=cut


