#!/usr/bin/ruby
require 'regexp_optimized_union'
input = Regexp.optimized_union(%w[poseidon son sonic poison])
puts input
open('/root/sandbox/regexp.re', 'w') { |f|
  f.puts input
}