#!/usr/bin/env perl
use strict;
use Regexp::Optimizer;
use Term::ANSIColor;
my $o = Regexp::Optimizer->new->optimize(qr/poseidon|son|poison|sonic/);
$o =~ s/\(\?\^\:|\)\)$//g;

my $str = <<END;
$o
END
my $dir = '/tmp/regexp.re';
open(FH, '>', $dir) or die $!;
print FH $str;
close(FH);
print "Writing to file successfully!\n";
#$o =~ s/\(\?\^\:|\)\)$//g;
#print colored( sprintf("$o"), 'red on_bright_yellow' ), "\n";
#print colored ['BOLD','red on_bright_yellow'], $o, "\n";
print color("ansi59"),"$o\n";

my $string = "$o";
my $count = ($string =~ s/\?:/ /g);
print color("bold black"), "Non capturing group: ", color("reset"), color("bold ansi243"), "$count", color("reset"), "\n";

my $length = length "$o";
#print colored("Size: $length", 'green'), "byte\n";
print color("bold black"), "Size: ",color("reset"), color("bold ansi243"), "$length", color("reset"), color("ansi243"), "byte\n";





