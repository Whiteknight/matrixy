use strict;
use warnings;
use 5.008;

use lib "../../lib"; 
use Parrot::Configure;
use Parrot::Configure::Options qw( process_options );

$| = 1;    # $OUTPUT_AUTOFLUSH = 1;

my $args = process_options(
    {
        step => 'gen::makefiles',
        mode => 'reconfigure',
        conditioned_lines => 1,
        replace_slashes => 1,
    }
);
exit(1) unless ( defined $args );

my $conf = Parrot::Configure->new;
$conf->options->set( %{$args} );
$conf->data()->get_PConfig(); #load configuration data

my @builtins = glob("src/builtins/*.pir");
$conf->data()->set('builtins_pir', join(' ', @builtins));

my @internals = glob("src/internals/*.pir");
$conf->data()->set('internals_pir', join(' ', @internals));

$conf->genfile( 'config/makefiles/root.in' => 'Makefile');

exit(0);
