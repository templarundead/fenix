#!/usr/bin/env perl
use strict;
use Regexp::Trie;
use Term::ANSIColor;
my $o = Regexp::Trie->new;
for (qw/poseidon son poison sonic/)
{$o->add($_)}

my $re = $o->regexp, "\n";
$re =~ s/\^|\\//g;

#print $re, "\n"


my $str = <<END;
$re
END
my $dir = '/root/sandbox/regexp.re';
open(FH, '>', $dir) or die $!;
print FH $str;
close(FH);
print "Writing to file successfully!\n";
#$o =~ s/\(\?\^\:|\)\)$//g;
#print colored( sprintf("$o"), 'red on_bright_yellow' ), "\n";
#print colored ['BOLD','red on_bright_yellow'], $o, "\n";
print color("ansi59"),"$re\n";

my $string = "$re";
my $count = ($string =~ s/\?:/ /g);
print color("bold black"), "Non capturing group: ", color("reset"), color("bold ansi243"), "$count", color("reset"), "\n";

my $length = length "$re";
#print colored("Size: $length", 'green'), "byte\n";
print color("bold black"), "Size: ",color("reset"), color("bold ansi243"), "$length", color("reset"), color("ansi243"), "byte\n";