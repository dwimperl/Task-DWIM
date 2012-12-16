#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Task::DWIM;

my %modules = Task::DWIM::get_modules();
plan tests => 2 * scalar keys %modules;

my %SKIP = (
    'Readonly::XS' => 'Readonly::XS is not stand alone module.',
);

foreach my $name (keys %modules) {
    SKIP: {
        skip $SKIP{$name}, 1 if $SKIP{$name};
        no warnings 'redefine';
        eval "use $name ()";
        is $@, '', $name;
    }
    SKIP: {
        skip $SKIP{$name}, 1 if $SKIP{$name};
        skip "Need ENV variable VERSION to check exact version ", 1 if not $ENV{VERSION};
        is $name->VERSION, $modules{$name}, "Version of $name";
    }
}
