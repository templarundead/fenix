#!/usr/bin/env perl
use strict;
use Regex::PreSuf;
use Term::ANSIColor;
my $o = presuf(qw(

ghost
frost
post

));
$o =~ s/\\//g;

my $str = <<END;
$o
END
my $dir = '/tmp/regexp.re';
open(FH, '>', $dir) or die $!;
print FH $str;
close(FH);
print "Writing to file successfully!\n";
print color("ansi59"),"$o\n";

my $string = "$o";
my $count = ($string =~ s/\?:/ /g);
print color("bold black"), "Non capturing group: ", color("reset"), color("bold ansi243"), "$count", color("reset"), "\n";

my $length = length "$o";
#print colored("Size: $length", 'green'), "byte\n";
print color("bold black"), "Size: ",color("reset"), color("bold ansi243"), "$length", color("reset"), color("ansi243"), "byte\n";
