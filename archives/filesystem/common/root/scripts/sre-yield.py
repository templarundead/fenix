#!/usr/bin/env python
import sre_yield
s = 'foo|ba[rz]'
output = list(sre_yield.AllStrings(s))
print(output)