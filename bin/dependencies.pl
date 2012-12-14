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
    die Dumper $dist;
}
