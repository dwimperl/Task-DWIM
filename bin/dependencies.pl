#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use lib 'lib';

use Data::Dumper;
use MetaCPAN::API;
use Task::DWIM;

my $mcpan = MetaCPAN::API->new;

my %modules = Task::DWIM::get_modules();

foreach my $name (sort keys %modules) {
    my $module   = $mcpan->module( $name );
    my $dist     = $mcpan->release( distribution => $module->{distribution} );
    say "$module->{distribution}  $module->{version}";
    foreach my $dependency (@{ $dist->{dependency} }) {
       say "   $dependency->{module}  $dependency->{version}"
    }
    #print Dumper $dist;
}

# Convert the modules.txt to some other format (JSON or YAML ?)
# list of module => version
# list of module => distribution
# in the end we actually install distributions, so we probably
# need a list of those with version numbers and full path
# we would also need a dependency mapping so we know the order of installation

