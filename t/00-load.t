#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Task::DWIM;

my %modules = Task::DWIM::get_modules();
plan tests => 2 * scalar keys %modules;

foreach my $name (keys %modules) {
    no warnings 'redefine';
    eval "use $name ()";
    is $@, '', $name;
    SKIP: {
       skip "Need ENV variable VERSION to check exact version " if not $ENV{VERSION};
       is $name->VERSION, $modules{$name}, "Version of $name";
    }
}
