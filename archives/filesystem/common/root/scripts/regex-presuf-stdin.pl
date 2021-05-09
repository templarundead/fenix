#!/usr/bin/env perl
use strict;
use warnings;
use Term::ANSIColor;
use Regex::PreSuf;
 
print colored("Enter word list here:", 'ansi101'), "\n";
my $list = <STDIN>;
chomp $list;

my $regex =  presuf(split / /, $list);

my $str = <<END;
$regex
END
my $dir = '/tmp/regexp.re';
open(FH, '>', $dir) or die $!;
print FH $str;
close(FH);
print "Writing to file successfully!\n";
