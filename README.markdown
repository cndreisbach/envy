# envy.pl

Envy is a command-line note-taking program heavily inspired by
[Notational Velocity](http://notational.net/). Its name is taken
both from the initials of Notational Velocity and from the feeling
I have when I see people using NV. It should work with the files 
in your current NV folder, if you want to use both.

This is an 0.1 version! It kind of sucks! 

## Installation

To install envy, run the following commands:

	perl Makefile.PL
	make
	make test
	make install

If everything works as expected, running `perl Makefile.PL` will ask you if
you want to download the necessary modules from CPAN. If not, you will need
to install Curses::UI, String::Approx, and File::Path::Expand from CPAN.

## Support and Documentation

After installing, you can find documentation for this program with the
man or perldoc commands.

    man envy.pl
    perldoc envy.pl

## License and Copyright

Copyright 2011 Clinton R. Nixon.

This program is free software. It comes without any warranty, to
the extent permitted by applicable law. You can redistribute it
and/or modify it under the terms of the Do What The Fuck You Want
To Public License, Version 2, as published by Sam Hocevar. See
http://sam.zoy.org/wtfpl/COPYING for more details.
