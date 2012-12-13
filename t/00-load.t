#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Task::DWIM;

my $modules = Task::DWIM::read_modules();
plan tests => scalar keys %$modules;

foreach my $name (keys %$modules) {
    no warnings 'redefine';
    eval "use $name ()";
    is $@, '', $name;
}
