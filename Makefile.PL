use inc::Module::Install;

name           'Task-DWIM';
all_from       'lib/Task/DWIM.pm';
#build_requires 'Test::More'                => '0.42';
#build_requires 'File::Spec'                => '0.80';

open my $fh, '<', 'modules.txt' or die;
while (my $line = <$fh>) {
    chomp $line;
    next if $line =~ /^\s*(#.*)?$/;
    my ($module, $version) = split /\s*=\s*/, $line;
    requires $module => $version;
}
close $fh;

repository 'https://github.com/dwimperl/Task-DWIM';

WriteAll;

