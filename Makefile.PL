use inc::Module::Install;

name           'Task-DWIM';
all_from       'lib/Task/DWIM.pm';
#build_requires 'Test::More'                => '0.42';
#build_requires 'File::Spec'                => '0.80';

my $modules = read_modules();
foreach my $name (keys %$modules) {
    requires $name => $modules->{$name};
}

repository 'https://github.com/dwimperl/Task-DWIM';

WriteAll;


sub read_modules {
    my %modules;
    open my $fh, '<', 'modules.txt' or die;
    while (my $line = <$fh>) {
        chomp $line;
        next if $line =~ /^\s*(#.*)?$/;
        $line =~ s/\s*#.*//;
        my ($name, $version) = split /\s*=\s*/, $line;
        if (exists $modules{$name}) {
            die "Module '$name' has 2 entries. One with '$modules{$name}' and the other one with '$version'";
        }
        $modules{$name} = $version;
    }
    close $fh;
    return \%modules;
}


