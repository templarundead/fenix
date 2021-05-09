#!/usr/bin/env perl
use Clipboard;
print Clipboard->paste;
Clipboard->copy('foo');