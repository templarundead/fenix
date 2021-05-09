#!/usr/bin/env perl
use strict;
use Regexp::Optimizer;
use Term::ANSIColor;

print colored("Enter word list here:", 'ansi101'), "\n";
my $list = <STDIN>;
chomp $list;


my $gh = qr/$list/;

my $regex = Regexp::Optimizer->new->optimize(split /\|/, $gh);

my $str = <<END;
$regex
END
my $dir = '/tmp/regexp.re';
open(FH, '>', $dir) or die $!;
print FH $str;
close(FH);
print "Writing to file successfully!\n";
print "$regex", "\n";