#!perl
#
# Documentation, copyright and license is at the end of this file.
#

package  File::AnySpec;

use 5.001;
use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE);
$VERSION = '1.1';
$DATE = '2003/07/15';

use SelfLoader;
use File::Spec;
use File::PM2File;
use File::Package;

######
#
# Having trouble with requires in Self Loader
#
#####

######
# Many of the methods in this package are use the File::Spec
# module submodules. 
#
# The L<File::Spec||File::Spec> uses the current operating system,
# as specified by the $^O to determine the proper File::Spec submodule
# to use.
#
# Thus, when using File::Spec method, only the submodule for
# the current operating system is loaded and the File::Spec
# method directed to the corresponding method of the
# File::Spec submodule.
#
my %module = (
      MacOS   => 'Mac',
      MSWin32 => 'Win32',
      os2     => 'OS2',
      VMS     => 'VMS',
      epoc    => 'Epoc');

sub fspec2module
{
    my (undef,$fspec) = @_;
    $module{$fspec} || 'Unix';
}


#####
# Convert between file specifications for different operating systems to a Unix file specification
#
sub fspec2fspec
{
    my (undef, $from_fspec, $to_fspec, $fspec_file, $nofile) = @_;

    return $fspec_file if $from_fspec eq $to_fspec;

    #######
    # Extract the raw @dirs, file
    #
    my $from_module = File::AnySpec->fspec2module( $from_fspec );
    my $from_package = "File::Spec::$from_module";
    my $error = File::Package->load_package($from_package);
    if( $error ) {
         warn $error;
         return undef;
    }
    my (undef, $fspec_dirs, $file) = $from_package->splitpath( $fspec_file, $nofile); 
    my @dirs = ($fspec_dirs) ? $from_package->splitdir( $fspec_dirs ) : ();

    return $file unless @dirs;  # no directories, file spec same for all os

    #######
    # Contruct the new file specification
    #
    my $to_module = File::AnySpec->fspec2module( $to_fspec );
    my $to_package = "File::Spec::$to_module";
    $error = File::Package->load_package( $to_package);
    if( $error ) {
         warn $error;
         return undef;
    }
    my @dirs_up;
    foreach my $dir (@dirs) {
       $dir = $to_package->updir() if $dir eq $to_package->updir();
       push @dirs_up, $dir;
    }
    return $to_package->catdir(@dirs_up) if $nofile;
    $to_package->catfile(@dirs_up, $file); # to native operating system file spec

}

######
#
#
sub pm2fspec
{
   my (undef, $fspec, $pm) = @_;
   my ($file,$path, $require) = File::PM2File->pm2file($pm);
   $file = File::AnySpec->os2fspec( $fspec, $file);
   $require = File::AnySpec->os2fspec( $fspec, $require);
   $path = File::AnySpec->os2fspec( $fspec, $path, 'nofile');
   ($file, $path, $require)
}

1

__DATA__


#####
#
#
sub os2fspec
{
    my (undef, $fspec, $os_file, $nofile) = @_;
    File::AnySpec->fspec2fspec($^O, $fspec, $os_file, $nofile);
}

#####
#
#
sub fspec2os
{
    my (undef, $fspec, $fspec_file, $nofile) = @_;
    File::AnySpec->fspec2fspec($fspec, $^O, $fspec_file, $nofile);
}

#######
#
# Glob a file specification
#
sub fspec_glob
{
   my (undef, $fspec, @files) = @_;

   use File::Glob ':glob';

   my @glob_files = ();
   foreach my $file (@files) {
       $file = File::AnySpec->fspec2os($fspec, $file);
       push @glob_files, bsd_glob( $file );
   }
   @glob_files;
}




sub fspec2pm
{
    my (undef, $fspec, $fspec_file) = @_;

    ##########
    # Must be a pm to convert to :: specification
    #
    return $fspec_file unless ($fspec_file =~ /\.pm$/);

    my $module = File::AnySpec->fspec2module( $fspec );
    my $fspec_package = "File::Spec::$module";
    File::Package->load_package( $fspec_package);
    
    #####
    # extract the raw @dirs and file from the file spec
    # 
    my (undef, $fspec_dirs, $file) = $fspec_package->splitpath( $fspec_file ); 
    my @dirs = $fspec_package->splitdir( $fspec_dirs );
    pop @dirs unless $dirs[-1]; # sometimes get empty for last directory

    #####
    # Contruct the pm specification
    #
    $file =~ s/\..*?$//g; # drop extension
    $file = join '::', (@dirs,$file);    
    $file
}

1

__END__

=head1 NAME

File::AnySpec - perform operations on foreign (remote) file names

=head1 SYNOPSIS

 use File::AnySpec

 $file                                 = File::FileUtil->fspec2fspec($from_fspec, $to_fspec $fspec_file, [$nofile])
 $os_file                              = File::FileUtil->fspec2os($fspec, $file, [$no_file])
 $fspec_file                           = File::FileUtil->os2fspec($fspec, $file, [$no_file])

 $pm                                   = File::FileUtil->fspec2pm($fspec, $require_file)
 ($abs_file, $inc_path, $require_file) = File::FileUtil->pm2fspec($fspec, $pm)

 @globed_files                         = File::FileUtil->fspec_glob($fspec, @files)


=head1 DESCRIPTION

Methods in this package, perform operations on file specifications for 
operating systems other then the current site operating system.
The input variable I<$fspec> tells the methods in this package
the file specification for file names used as input to the methods.
Thus, when using methods in this package, the method may 
load up to two L<File::Spec||File::Spec> submodules methods and
neither of them is a submodule for the current site operating
system.

Supported operating system file specifications are as follows:

 MacOS
 MSWin32
 os2
 VMS
 epoc

Of course since, the variable I<$^O> contains the file specification
for the current site operating system, it may be used for the
I<$fspec> variable.

=head2 fspec_glob method

  @globed_files = File::FileUtil->fspec_glob($fspec, @files)

The I<fspec_glob> method BSD globs each of the files in I<@files>
where the file specification for each of the files is I<$fspec>.

=head2 fspec2fspec method

 $to_file = File::FileUtil->fspec2fspec($from_fspec, $to_fspec $from_file, $nofile)

THe I<fspec2fspec> method translate the file specification for I<$from_file> from
the I<$from_fspec> to the I<$to_fpsce>. Supplying anything for I<$nofile>, tells
the I<fspec2fspec> method that I<$from_file> is a directory tree; otherwise, it
is a file.

=head2 fspec2os method

  $os_file = File::FileUtil->fspec2os($fspec, $file, $no_file)

The I<fspec2os> method translates a file specification, I<$file>, from the
current operating system file specification to the I<$fspec> file specification.
Supplying anything for I<$nofile>, tells
the I<fspec2fspec> method that I<$from_file> is a directory tree; otherwise, it
is a file.

=head2 fspec2pm method

 $pm_file = File::FileUtil->fspec2pm( $fspec, $relative_file )

The I<fspec2pm> method translates a filespecification I<$file>
in the I<$fspce> format to the Perl module formate.

=head2 os2fspec method

 $file = File::FileUtil->os2fspec($fspec, $os_file, $no_file)

The I<fspec2os> method translates a file specification, I<$file>, from the
current operating system file specification to the I<$fspec> file specification.
Supplying anything for I<$nofile>, tells
the I<fspec2fspec> method that I<$from_file> is a directory tree; otherwise, it
is a file.

=head2 pm2file method

 ($abs_file, $inc_path, $require_file) = File::FileUtil->pm2file($pm)

The I<pm2file> method returns the absolute file and
the directory in I<@INC> for a the program module
I<$pm_file>.

=head1 REQUIREMENTS

Coming soon.

=head1 DEMONSTRATION

 ~~~~~~ Demonstration overview ~~~~~

Perl code begins with the prompt

 =>

The selected results from executing the Perl Code 
follow on the next lines. For example,

 => 2 + 2
 4

 ~~~~~~ The demonstration follows ~~~~~

 =>     use File::Spec;

 =>     use File::Package;
 =>     my $fp = 'File::Package';

 =>     my $as = 'File::AnySpec';

 =>     my $loaded = '';
 =>     my @drivers;
 =>     my @files;
 => my $errors = $fp->load_package( $as)
 => $errors
 ''

 => $as->fspec2fspec( 'Unix', 'MSWin32', 'File/FileUtil.pm')
 'File\FileUtil.pm'

 => $as->os2fspec( 'Unix', ($as->fspec2os( 'Unix', 'File/FileUtil.pm')))
 'File/FileUtil.pm'

 => $as->os2fspec( 'MSWin32', ($as->fspec2os( 'MSWin32', 'Test\\TestUtil.pm')))
 'Test\TestUtil.pm'

 => @drivers = sort $as->fspec_glob('Unix','Drivers/G*.pm')
 => join (', ', @drivers)
 'Drivers\Generate.pm'

 => $as->fspec2pm('Unix', 'File/AnySpec.pm')
 'File::AnySpec'

 => $as->pm2fspec( 'Unix', 'File::Basename')
 '/Perl/lib/File/Basename.pm'
 '/Perl/lib'
 'File/Basename.pm'


=head1 QUALITY ASSURANCE

The module "t::File::AnySpec" is the Software
Test Description(STD) module for the "File::AnySpec".
module. 

To generate all the test output files, 
run the generated test script,
run the demonstration script and include it results in the "File::AnySpec" POD,
execute the following in any directory:

 tmake -test_verbose -replace -run  -pm=t::File::AnySpec

Note that F<tmake.pl> must be in the execution path C<$ENV{PATH}>
and the "t" directory containing  "t::File::AnySpec" on the same level as the "lib" 
directory that contains the "File::AnySpec" module.

=head1 NOTES

=head2 AUTHOR

The holder of the copyright and maintainer is

E<lt>support@SoftwareDiamonds.comE<gt>

=head2 COPYRIGHT NOTICE

Copyrighted (c) 2002 Software Diamonds

All Rights Reserved

=head2 BINDING REQUIREMENTS NOTICE

Binding requirements are indexed with the
pharse 'shall[dd]' where dd is an unique number
for each header section.
This conforms to standard federal
government practices, 490A (L<STD490A/3.2.3.6>).
In accordance with the License, Software Diamonds
is not liable for any requirement, binding or otherwise.

=head2 LICENSE

Software Diamonds permits the redistribution
and use in source and binary forms, with or
without modification, provided that the 
following conditions are met: 

=over 4

=item 1

Redistributions of source code must retain
the above copyright notice, this list of
conditions and the following disclaimer. 

=item 2

Redistributions in binary form must 
reproduce the above copyright notice,
this list of conditions and the following 
disclaimer in the documentation and/or
other materials provided with the
distribution.

=back

SOFTWARE DIAMONDS, http::www.softwarediamonds.com,
PROVIDES THIS SOFTWARE 
'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
SHALL SOFTWARE DIAMONDS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL,EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE,DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING USE OF THIS SOFTWARE, EVEN IF
ADVISED OF NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE POSSIBILITY OF SUCH DAMAGE. 

=head2 SEE_ALSO:

=over 4

=item L<File::Spec|File::Spec>

=item L<File::AnySpec|File::AnySpec>

=back

=for html
<p><br>
<!-- BLK ID="NOTICE" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="OPT-IN" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="EMAIL" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="COPYRIGHT" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="LOG_CGI" -->
<!-- /BLK -->
<p><br>

=cut

### end of file ###