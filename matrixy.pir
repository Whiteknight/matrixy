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

.sub '__onload' :anon :load :init
    load_bytecode 'PCT.pbc'

    $P0 = get_hll_global ['PCT'], 'HLLCompiler'
    $P1 = $P0.'new'()
    $P1.'language'('matrixy')
    $P0 = get_hll_namespace ['Matrixy';'Grammar']
    $P1.'parsegrammar'($P0)
    $P0 = get_hll_namespace ['Matrixy';'Grammar';'Actions']
    $P1.'parseactions'($P0)

    $P1.'commandline_prompt'("\nmatrixy:1> ")
    $P1.'commandline_banner'("Matrixy, version 0.1.\nCopyright (C) 2009 See LICENSE for details")

    '__initglobals'()
.end

# TODO: This function is an initialization step for the parser. We should
#       initialize the parser so that state is not stored from one parse
#       to the next. Find a way to add this automatically into the
#       HLLCompiler object
.sub '__initglobals'
    # Parser data fields that we use to keep track of blocks
    $P0 = new 'ResizablePMCArray'
    set_hll_global ['Matrixy';'Grammar';'Actions'], '@?BLOCK', $P0
    $P0 = new 'Undef'
    set_hll_global ['Matrixy';'Grammar';'Actions'], '$?BLOCK', $P0

    # list of functions that we've compiled. We cache them to prevent needing
    # to recompile.
    # TODO: This isn't part of the parser, find a better namespace to hold this
    $P1 = new 'Hash'
    set_hll_global ['Matrixy';'Grammar';'Actions'], '%?FUNCTIONS', $P1

    # TODO: This isn't part of the parser, find a better namespace to hold this
    # TODO: !dispatch to "path()" to do this.
    # default path is set to current directory
    $P2 = new 'ResizablePMCArray'
    $P2[0] = "."
    $P2[1] = "toolbox/"
    set_hll_global ['Matrixy';'Grammar';'Actions'], '@?PATH', $P2

    # list of global variables defined with the "global" keyword
    $P3 = new 'Hash'
    set_hll_global ['Matrixy';'Grammar';'Actions'], '%?GLOBALS', $P3

    # TODO: We need a much better way to handle NARGIN. Might want to use
    #       :call_sig and process all our own arguments
    # list to keep track of arguments to a function so we can populate
    # NARGIN.
    $P0 = new 'ResizablePMCArray'
    set_hll_global['Matrixy';'Grammar';'Actions'], '@?PARAMS', $P0
.end

=item main(args :slurpy)  :main

Start compilation by passing any command line C<args>
to the Matrixy compiler.

=cut

.sub 'main' :main
    .param pmc args

    # TODO: We might want to add this sequence as a method on the compiler
    #       object, so we can call it from a library load too.
    # load start up file
    $P0 = null
    '!dispatch'('matrixyrc', $P0, 1, 1, 1)

    $P0 = compreg 'matrixy'
    $P1 = $P0.'command_line'(args)
.end

=back

=cut

.include 'src/gen_internals.pir'
.include 'src/gen_builtins.pir'
.include 'src/gen_grammar.pir'
.include 'src/gen_actions.pir'

