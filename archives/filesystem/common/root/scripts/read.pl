#!/usr/bin/env perl
use strict;
use warnings;
use Regex::PreSuf;

my $defaultfile = '/root/sandbox/reg.txt';
my @name        = $defaultfile;
my $mainfile    = '/tmp/regexp.re';

open( my $default_fh, "<", @name )     or die $!;
open( my $main_fh,    ">", $mainfile ) or die $!;
while ( my $line = <$default_fh> ) {
    print $main_fh presuf( split / /, $line );
    print presuf( split / /, $line );
}
close $default_fh;
close $main_fh