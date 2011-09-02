#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'App::Envy' ) || print "Bail out!
";
}

diag( "Testing App::Envy $App::Envy::VERSION, Perl $], $^X" );
