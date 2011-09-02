# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name            'App-Envy';
#abstract_from   'lib/App/Envy.pm';
abstract_from   'bin/envy.pl';
author          q{Clinton R. Nixon <crnixon@gmail.com>};
#version_from    'lib/App/Envy.pm';
version_from    'bin/envy.pl';

requires 'Curses::UI';
requires 'String::Approx';
requires 'File::Path::Expand';

install_script 'bin/envy.pl';
auto_install();
sign;
WriteAll;

