#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use lib 'lib';

use Data::Dumper;
use MetaCPAN::API;
use Task::DWIM;
use JSON qw(to_json from_json);
use File::Slurp qw(read_file write_file);
use Getopt::Long qw(GetOptions);
use Try::Tiny;

my %opt;
GetOptions(\%opt, 'update') or die;

my $filename = 'cpan.json';

my $data;

if (-e $filename) {
    $data = from_json scalar read_file $filename;
}

my $mcpan = MetaCPAN::API->new;

#my %modules = Task::DWIM::get_modules();
my %modules = (
    'Test::More' => 0,
);

foreach my $name (sort keys %modules) {
    next if $data->{modules}{$name} and not $opt{update}; #already collected
    process_module('Pod::Escapes');

    #my $module   = $mcpan->module( $name );
    #my $dist     = $mcpan->release( distribution => $module->{distribution} );
    #say "$module->{distribution}  $module->{version}";
    #foreach my $dependency (@{ $dist->{dependency} }) {
    #   say "   $dependency->{module}  $dependency->{version}"
    #}
    #print Dumper $dist;
    $data->{modules}{$name} = 2;
}

write_file $filename, to_json $data, {pretty => 1};


# Convert the modules.txt to some other format (JSON or YAML ?)
# list of module => version
# list of module => distribution
# in the end we actually install distributions, so we probably
# need a list of those with version numbers and full path
# we would also need a dependency mapping so we know the order of installation

sub process_distro {
    my ($name) = @_;

    return if exists $data->{distros}{$name};
    say STDERR "Processing distro $name";

    try {
        my $r = $mcpan->fetch( 'release/_search',
            q => 'distribution:Test-Simple AND status:latest',
            size => 1,
            fields => 'distribution,dependency,version,dowload_url', # license,archive
        );
        $data->{distros}{$name} = $r->{hits}{hits}[0]{fields};
    } catch {
        warn "Exception: $_";
    };
    return if not $data->{distros}{$name};

    foreach my $dep (@{ $data->{distros}{$name}{dependency} }) {
        process_module($dep->{module});
    }

    return;
}

sub process_module {
    my ($name) = @_;

    return if exists $data->{modules}{ $name };
    say STDERR "Processing module $name";

    try {
        my $r = $mcpan->module( $name );
        for my $field (qw(version distribution)) {
            #if (not defined $r->{$field}) {
            #    die Dumper $r;
            #}
            $data->{modules}{$name}{$field} = $r->{$field};
        }
    } catch {
        warn "Exception: $_";
    };
    return if not $data->{modules}{$name};
    process_distro($data->{modules}{$name}{distribution});

    return;
}

