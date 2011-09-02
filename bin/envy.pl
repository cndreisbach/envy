#!/usr/bin/perl
use strict;
use warnings;

=head1 NAME

envy - A command-line note-taking app inspired by Notational Velocity

=head1 VERSION

Version 0.01

=head1 DESCRIPTION

This is a simple curses app that emulates the base functionality of
Notational Velocity (http://notational.net/).

=head1 KEYS

When in the text entry area:

  <Enter> narrows the list of notes using the text you entered
  <Ctrl-C>, <Ctrl-Q>, and <Esc> all quit

When in the note list:

  <Enter> opens the currently highlighted note
  <Ctrl-Q> and <Esc> take you back to the text entry area
  <Ctrl-N> creates a new note with the text you entered
  <Ctrl-C> quits

=head1 AUTHOR

Clinton R. Nixon, C<< <crnixon at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to me at
https://github.com/crnixon/envy.

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Clinton R. Nixon.

This program is free software. It comes without any warranty, to
the extent permitted by applicable law. You can redistribute it
and/or modify it under the terms of the Do What The Fuck You Want
To Public License, Version 2, as published by Sam Hocevar. See
http://sam.zoy.org/wtfpl/COPYING for more details.

=cut

our $VERSION = '0.01';

use File::Path::Expand;
use Curses::UI;
use Curses::UI::Common;
use File::Basename;
use String::Approx 'amatch';

my $notedir = get_notedir();

my $editor = $ENV{'EDITOR'} || 'nano';
my @notefiles = <$notedir/*.txt>;
my %notehash = map { basename($_, '.txt') => $_ } @notefiles;

my $cui = new Curses::UI();
my $win = $cui->add('win', 'Window');

sub get_notedir {
  my $config_file = expand_filename("~/.envy");
  my $notedir = "";

  if (-e $config_file) {
    open FILE, $config_file or die $!;
    $notedir = <FILE>;
    close FILE;
    chomp($notedir);
  } else {
    print "Where do you want to store your notes? ";
    $notedir = <>;
    chomp($notedir);
    open FILE, ">$config_file" or die $!;
    print FILE $notedir;
    close FILE;
  }

  $notedir = expand_filename($notedir);
  if (! -e $notedir) {
    print "$notedir does not exist! Do you want me to create this directory? ";
    my $yn = <>;
    if ($yn =~ /^[Yy]/) {
      mkdir $notedir, 0755 or die $!;
    }
  }

  if ((! -d $notedir) || (! -w $notedir)) {
    unlink $config_file;
    die "There is some nonsense problem with $notedir! Check it out.";
  }

  return $notedir;
}

sub get_notes {
  my $term = shift;
  my @notes = sort keys(%notehash);
  
  if ($term) {
    return amatch($term, @notes);
  } else {
    return \@notes;
  }
}

sub open_note {
  my $note = shift;
  my $notefile = $notehash{$note};
  if ($notefile) {
    $cui->leave_curses();
    system($editor, $notefile);
    $cui->reset_curses();
  } else {
    $cui->dialog("Could not open note \"$note\".");
  }
}

sub create_note {
  my $notetitle = shift;
  my $notefile = "$notedir/$notetitle.txt";

  my $create = $cui->dialog(
    -message => "Create a new note \"$notetitle\"?",
    -buttons => [{
        -label => "Yes",
        -value => 1,
        -shortcut => 'y',
      }, {
        -label => "No",
        -value => 0,
        -shortcut => 'n'
      }
    ],
  );

  if ($create) {
    $notehash{$notetitle} = $notefile;
    open_note($notetitle);
  }
}

my $listbox = $win->add(
  'listbox', 'Listbox',
  -border => 1,
  -y => 3,
  -values => get_notes(),
  -onchange => sub {
    my $listbox = shift;
    open_note($listbox->get_active_value());
  }
);

my $textentry = $win->add(
  'mytextentry' => 'TextEntry',
  -border => 1,
  -onchange => sub { $listbox->values(get_notes($_[0]->get())) },
);

$textentry->set_binding(sub { $listbox->focus(); }, "<enter>");
$textentry->set_binding(sub { exit(0); }, "\cQ", CUI_ESCAPE);
$listbox->set_binding(sub { 
    $listbox->clear_selection();
    $textentry->text("");
    $listbox->values(get_notes());
    $listbox->lose_focus();
    $textentry->focus(); 
  }, "\cQ", CUI_ESCAPE);
$cui->set_binding(sub { exit(0); }, "\cC");
$cui->set_binding(sub {
    create_note($textentry->get());
  }, "\cN");

$textentry->focus();
$cui->mainloop();
