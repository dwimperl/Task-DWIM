package Task::DWIM;

use 5.008;
use strict;
our $VERSION = '0.04';

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


1;

__END__

=pod

=head1 NAME

Task::DWIM - A Task module for DWIM Perl L<http://dwimperl.com/>

=head1 DESCRIPTION

Just a list of modules to be installed as part of the DWIM Perl distribution

=head1 AUTHOR

Gabor Szabo E<lt>szabgab@cpan.orgE<gt>

If you are interested, contact me to take over the maintenance.

=head1 SEE ALSO

L<Task>, L<http://dwimperl.com/>

=head1 COPYRIGHT

Copyright 2012 Gabor Szabo.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

