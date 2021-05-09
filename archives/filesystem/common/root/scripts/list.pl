#!/usr/bin/env perl
use strict;
use Regexp::Trie;
my $rt = Regexp::Trie->new;
for (qw/all-petite-caps all-scroll all-small-caps allow-end/)
{$rt->add($_)}
print $rt->regexp, "\n";