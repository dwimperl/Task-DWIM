use strict;
use warnings;

use Cwd qw(cwd);
use File::Copy qw(copy move);
use File::Path qw(mkpath);
use File::Temp qw(tempdir);
use File::Slurp qw(read_file write_file);

opendir my $dh, 'lists' or die;
my $pwd = cwd();

my $test = shift;

foreach my $file (readdir $dh) {
    next if $file eq '.' or $file eq '..';
    my $name = substr $file, 0, -4;
    next if $name !~ /^[A-Z]/;

    print "\n\n******************Processing $name\n";
    my $dir = tempdir(CLEANUP => 1);
    print "$dir\n";
    mkpath "$dir/lib/Task/DWIM" or die;
    mkdir  "$dir/t" or die;
    mkdir  "$dir/lists" or die;

    # create file "$dir/lib/Task/DWIM/$name.pm";
    my $module = read_file 'lib/Task/DWIM.pm';
    $module =~ s/Task::DWIM/Task::DWIM::$name/g;
    write_file "$dir/lib/Task/DWIM/$name.pm", $module;

    # create Makefile.PL
    my $makefile = read_file 'Makefile.PL';
    $makefile =~ s/Task::DWIM/Task::DWIM::$name/g;
    $makefile =~ s/Task-DWIM/Task-DWIM-$name/; # don't change for the repository
    $makefile =~ s{DWIM\.pm}{DWIM/$name.pm};
    write_file "$dir/Makefile.PL", $makefile;

    # create t/
    my $t_file = read_file 't/00-load.t';
    $t_file =~ s/Task::DWIM/Task::DWIM::$name/g;
    write_file "$dir/t/00-load.t", $t_file;

    copy "lists/$file", "$dir/lists/" or die "Could not copy '$file' $!";
    copy 'MANIFEST.SKIP', "$dir/" or dir $!;
    copy 'README', "$dir/" or dir $!;

    chdir $dir or die;
    system "$^X Makefile.PL" and die;
    system "make" and die;
    system "make manifest" and die;
    if ($test) {
        system "make test" and die;
    }

    system "make dist" and die;

    my ($gz_file) = glob "*.gz";
    move $gz_file, $pwd or die $!;

    chdir $pwd;
}

