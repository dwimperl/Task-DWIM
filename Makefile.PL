use inc::Module::Install;
use lib 'lib';
use Task::DWIM;

name           'Task-DWIM';
all_from       'lib/Task/DWIM.pm';
#build_requires 'Test::More'                => '0.42';
#build_requires 'File::Spec'                => '0.80';

requires perl  => 5.008;

my %modules = Task::DWIM::get_modules();
foreach my $name (keys %modules) {
    requires $name => $modules{$name};
}

repository 'https://github.com/dwimperl/Task-DWIM';

WriteAll;


