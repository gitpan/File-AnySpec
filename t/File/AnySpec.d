#!perl
#
#
use 5.001;
use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE);
$VERSION = '0.01';   # automatically generated file
$DATE = '2003/07/04';


##### Demonstration Script ####
#
# Name: AnySpec.d
#
# UUT: File::AnySpec
#
# The module Test::STDmaker generated this demo script from the contents of
#
# t::File::AnySpec 
#
# Don't edit this test script file, edit instead
#
# t::File::AnySpec
#
#	ANY CHANGES MADE HERE TO THIS SCRIPT FILE WILL BE LOST
#
#       the next time Test::STDmaker generates this script file.
#
#

######
#
# The working directory is the directory of the generated file
#
use vars qw($__restore_dir__ @__restore_inc__ );

BEGIN {
    use Cwd;
    use File::Spec;
    use File::TestPath;
    use Test::Tech qw(tech_config plan demo);

    ########
    # Working directory is that of the script file
    #
    $__restore_dir__ = cwd();
    my ($vol, $dirs, undef) = File::Spec->splitpath(__FILE__);
    chdir $vol if $vol;
    chdir $dirs if $dirs;

    #######
    # Add the library of the unit under test (UUT) to @INC
    #
    @__restore_inc__ = File::TestPath->test_lib2inc();

    unshift @INC, File::Spec->catdir( cwd(), 'lib' ); 

}

END {

   #########
   # Restore working directory and @INC back to when enter script
   #
   @INC = @__restore_inc__;
   chdir $__restore_dir__;

}

print << 'MSG';

 ~~~~~~ Demonstration overview ~~~~~
 
Perl code begins with the prompt

 =>

The selected results from executing the Perl Code 
follow on the next lines. For example,

 => 2 + 2
 4

 ~~~~~~ The demonstration follows ~~~~~

MSG

demo( "\ \ \ \ use\ File\:\:Spec\;\
\
\ \ \ \ use\ File\:\:Package\;\
\ \ \ \ my\ \$fp\ \=\ \'File\:\:Package\'\;\
\
\ \ \ \ my\ \$as\ \=\ \'File\:\:AnySpec\'\;\
\
\ \ \ \ my\ \$loaded\ \=\ \'\'\;\
\ \ \ \ my\ \@drivers\;\
\ \ \ \ my\ \@files\;"); # typed in command           
          use File::Spec;

    use File::Package;
    my $fp = 'File::Package';

    my $as = 'File::AnySpec';

    my $loaded = '';
    my @drivers;
    my @files;; # execution

demo( "my\ \$errors\ \=\ \$fp\-\>load_package\(\ \$as\)"); # typed in command           
      my $errors = $fp->load_package( $as); # execution

demo( "\$errors", # typed in command           
      $errors # execution
) unless     $loaded; # condition for execution                            

demo( "\$as\-\>fspec2fspec\(\ \'Unix\'\,\ \'MSWin32\'\,\ \'File\/FileUtil\.pm\'\)", # typed in command           
      $as->fspec2fspec( 'Unix', 'MSWin32', 'File/FileUtil.pm')); # execution


demo( "\$as\-\>os2fspec\(\ \'Unix\'\,\ \(\$as\-\>fspec2os\(\ \'Unix\'\,\ \'File\/FileUtil\.pm\'\)\)\)", # typed in command           
      $as->os2fspec( 'Unix', ($as->fspec2os( 'Unix', 'File/FileUtil.pm')))); # execution


demo( "\$as\-\>os2fspec\(\ \'MSWin32\'\,\ \(\$as\-\>fspec2os\(\ \'MSWin32\'\,\ \'Test\\\\TestUtil\.pm\'\)\)\)", # typed in command           
      $as->os2fspec( 'MSWin32', ($as->fspec2os( 'MSWin32', 'Test\\TestUtil.pm')))); # execution


demo( "\@drivers\ \=\ sort\ \$as\-\>fspec_glob\(\'Unix\'\,\'Drivers\/G\*\.pm\'\)"); # typed in command           
      @drivers = sort $as->fspec_glob('Unix','Drivers/G*.pm'); # execution

demo( "join\ \(\'\,\ \'\,\ \@drivers\)", # typed in command           
      join (', ', @drivers)); # execution


demo( "\$as\-\>fspec2pm\(\'Unix\'\,\ \'File\/AnySpec\.pm\'\)", # typed in command           
      $as->fspec2pm('Unix', 'File/AnySpec.pm')); # execution


demo( "\$as\-\>pm2fspec\(\ \'Unix\'\,\ \'File\:\:Basename\'\)", # typed in command           
      $as->pm2fspec( 'Unix', 'File::Basename')); # execution



=head1 NAME

AnySpec.d - demostration script for File::AnySpec

=head1 SYNOPSIS

 AnySpec.d

=head1 OPTIONS

None.

=head1 COPYRIGHT

copyright © 2003 Software Diamonds.

Software Diamonds permits the redistribution
and use in source and binary forms, with or
without modification, provided that the 
following conditions are met: 

=over 4

=item 1

Redistributions of source code, modified or unmodified
must retain the above copyright notice, this list of
conditions and the following disclaimer. 

=item 2

Redistributions in binary form must 
reproduce the above copyright notice,
this list of conditions and the following 
disclaimer in the documentation and/or
other materials provided with the
distribution.

=back

SOFTWARE DIAMONDS, http://www.SoftwareDiamonds.com,
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

## end of test script file ##

=cut

