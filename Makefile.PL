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


#requires     'MooseX::StrictConstructor'        => '0';
#requires     'MooseX::Params::Validate'         => '0';
#requires     'MooseX::Role::TraitConstructor'   => '0';
#requires     'MooseX::Traits'                   => '0';
#requires     'MooseX::Object::Pluggable'        => '0';
#MooseX::Role::Parameterized MooseX::GlobRef MooseX::InsideOut MooseX::Singleton MooseX::NonMoose MooseX::Declare
#MooseX::Method::Signatures TryCatch MooseX::Types MooseX::Types::Structured MooseX::Types::Path::Class
#Set::Object MooseX::Types::Set::Object DateTime MooseX::Types::DateTime MooseX::Getopt MooseX::ConfigFromFile
#MooseX::SimpleConfig MooseX::App::Cmd MooseX::Role::Cmd MooseX::LogDispatch MooseX::LazyLogDispatch
#MooseX::Log::Log4perl MooseX::POE MooseX::Workers MooseX::Daemonize MooseX::Param MooseX::Iterator
#MooseX::Clone MooseX::Storage Moose::Autobox MooseX::ClassAttribute MooseX::SemiAffordanceAccessor
#namespace::autoclean Pod::Coverage::Moose


# repository 'https://github.com/szabgab/Task-DWIM';

WriteAll;

