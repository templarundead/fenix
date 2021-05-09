#!/usr/bin/env perl
use strict;
use warnings;
use Regex::PreSuf;

my $text = '/root/sandbox/word.txt';
my @name = split /,/, $text;

open(fh, '<', @name) or die $!;
my $firstline = <fh>;
print presuf($firstline), "\n";
