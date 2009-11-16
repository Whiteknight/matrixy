# Purpose: Use Parrot's config info to configure our Makefile.
#
# Usage:
#     parrot_nqp Configure.nqp

our @ARGS;
our %VM;
our $OS;

MAIN();

sub MAIN () {
    # Wave to the friendly users
    say("Hello, I'm Configure. My job is to poke and prod your system");
    say("to figure out how to build matrixy.\n");

    # Load Parrot config and glue functions
    load_bytecode('config/config-helpers.pir');

    # Check for linalg_group
    Q:PIR {
        .local pmc pla
        pla = loadlib "linalg_group"
        if pla goto linalg_group_loaded
        goto cannot_load_library
      linalg_group_loaded:
        push_eh cannot_load_library
        $P0 = new ['NumMatrix2D']
        goto everything_is_fine
      cannot_load_library:
        say "linalg_group not found"
        say "You must install the parrot-linear-algebra package before"
        say "installing Matrixy."
        say "http://www.github.com/Whiteknight/parrot-linear-algebra"
        exit 1
      everything_is_fine:
        say "linalg_group loaded OK"
    };

    # Slurp in the unconfigured Makefile text
    my $unconfigured := slurp(@ARGS[0] || 'config/makefiles/root.in');

    # Replace all of the @foo@ markers
    my $replaced := subst($unconfigured, rx('\@<ident>\@'), replacement);

    # Fix paths on Windows
    if ($OS eq 'MSWin32') {
        $replaced := subst($replaced, rx('/'), '\\');
    }

    # Spew out the final makefile
    spew(@ARGS[1] || 'Makefile', $replaced);

    # Give the user a hint of next action
    say("Configure completed.");
    say("You can now type '" ~ %VM<config><make> ~ "' to build matrixy.\n");
    say("You may also type '" ~ %VM<config><make> ~ " test' to run the test suite.\n");
    say("Happy Hacking,");
    say("\tThe matrixy Team");
}

sub replacement ($match) {
    my $key    := $match<ident>;
    my $config := %VM<config>{$key} || '';

    return $config;
}
