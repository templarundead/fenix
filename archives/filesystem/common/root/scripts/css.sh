#!/usr/bin/env bash

for i in *.css;
do prettier --use-tabs --write "$i";
done