#!perl
#
# Documentation, copyright and license is at the end of this file.
#
package  Text::Scrub;

use 5.001;
use strict;
use warnings;
use warnings::register;

use SelfLoader;

use vars qw($VERSION $DATE $FILE);
$VERSION = '1.09';
$DATE = '2003/07/26';
$FILE = __FILE__

__DATA__

#######
# Blank out the Verion, Date for comparision
#
#
sub scrub_file_line
{
    my (undef, $text) = @_;

    return $text unless $text;

    ######
    # Blank out version and date for comparasion
    #
    $text =~ s/\(.*?at line \d+/(xxxx.t at line 000/ig;
    $text

}


#######
# Blank out the Verion, Date for comparision
#
#
sub scrub_test_file
{
    my (undef, $text) = @_;

    return $text unless $text;

    ######
    # Blank out version and date for comparasion
    #
    $text =~ s/Running Tests.*?1\.\./Running Tests xxx.t 1../sig;
    $text

}

#####
# 
# Scrub date
#
#
sub scrub_date
{
    my (undef, $text) = (@_);
    $text =~ s|([ '"(]?)\d{2,4}/\d{1,2}/\d{1,2}([ '")\n]?)|${1}1969/02/06${2}|g;
    $text

}

#######
# Blank out the Verion, Date for comparision
#
#
sub scrub_date_version
{
    my (undef, $text) = @_;

    return $text unless $text;

    ######
    # Blank out version and date for comparasion
    #
    $text =~ s/\$VERSION\s*=\s*['"].*?['"]/\$VERSION = '0.00'/ig;      
    $text =~ s/\$DATE\s*=\s*['"].*?['"]/\$DATE = 'Feb 6, 1969'/ig;
    $text =~ s/DATE:\s+.*?\n/\$DATE: Feb 6, 1969\n/ig;
    $text

}

#####
# Date changes between runs so cannot have
# a static compare file unless you eliminate
# the date. Also the ticket is different
#
sub scrub_date_ticket
{
    my (undef, $email) = @_;

    $email =~ s/Date: .*?\n/Date: Feb 6 00 00 00 1969 +0000\n/ig;

    $email =~ s/Subject: .*?,(.*)\n/Subject: XXXXXXXXX-X, $1\n/ig;

    $email =~ s/X-SDticket:.*?\n/X-SDticket: XXXXXXXXX-X\n/ig;

    $email =~ s/\QFrom ???@???\E .*?\n/From ???@??? Feb 6 00 00 00 1969 +0000\n/ig;

    $email =~ s/X-eudora-date: .*?\n/X-eudora-date: Feb 6 00 00 00 1969 +0000\n/ig;

    $email =~ s/X-SDmailit: sent .*?\n/X-SDmailit: sent Sat Feb 6 00 00 00 1969 +0000\n/ig;

    $email =~ s/X-SDmailit: dead .*?\n/X-SDmailit: dead Sat Feb 6 00 00 00 1969 +0000\n/ig;

    $email =~ s/Sent email \S+ to (.*?)\n/Sent email XXXXXXXXX-X to $1\n/ig;

    open OUT, '> actual.txt';  # use to gen the expected
    print OUT $email;
    close OUT;;
    $email;
}



#####
#
#
sub scrub_probe
{
   my (undef, $text) = @_;
   $text =~ s/^(.*?\n)(.*?)\#\s+=cut\s*\n/$1/s;
   $text
}



1


__END__

=head1 NAME
  
Text::STDutil - used to wild card out text used for comparison

=head1 SYNOPSIS

  use Text::Scrub

  $scrubbed_text = Text::Scrub->scrub_date($script_text)
  $scrubbed_text = Text::Scrub->scrub_date_ticket($script_text)
  $scrubbed_text = Text::Scrub->scrub_date_version($script_text)
  $scrubbed_text = Text::Scrub->scrub_file_line($script_text)
  $scrubbed_text = Text::Scrub->scrub_probe($script_text)
  $scrubbed_text = Text::Scrub->scrub_test_file($script_text)

=head1 DESCRIPTION

The methods in the C<Test::STD:Scrub> package are designed to support the
L<C<Test::STDmaker>|Test::STDmaker> and 
the L<C<ExtUtils::SVDmaker>|ExtUtils::SVDmaker> package.
This is the focus and no other focus.
Since C<Test::STD::Scrub> is a separate package, the methods
may be used elsewhere.
In all likehood, any revisions will maintain backwards compatibility
with previous revisions.
However, support and the performance of the 
L<C<Test::STDmaker>|Test::STDmaker> and 
L<C<ExtUtils::SVDmaker>|ExtUtils::SVDmaker> packages has
priority over backwards compatibility.

=head2 scrub_date_ticket

 $scrubbed_text = Test::STD::Scrub->scrub_date_ticket($script_text)

When comparing the contents of email messages, 
the date and email ticket should not be used 
in the comparision. 
The I<scrub_date_ticket> method will replace
the date and email ticket with a generic value.
Applying the I<scrub_date_ticket> to the contents
of both files before the comparision will 
eliminate the data and ticket as factors in
the comparision.

For example,

 ==> $text

 Date: Feb 6 00 00 00 1969 +0000
 Subject: 20030506, This Week in Health
 X-SDticket: 20030205
 X-eudora-date: Feb 6 2000 00 00 2003 +0000
 X-SDmailit: dead Feb 5 2000 00 00 2003
 Sent email 20030205 to support.softwarediamonds.com
 
 ==> Test::STD::Scrub->scrub_date_ticket($text)

 Date: Feb 6 00 00 00 1969 +0000
 Subject: XXXXXXXXX-X,  This Week in Health'
 X-SDticket: XXXXXXXXX-X
 X-eudora-date: Feb 6 00 00 00 1969 +0000
 X-SDmailit: dead Sat Feb 6 00 00 00 1969 +0000
 Sent email XXXXXXXXX-X to support.softwarediamonds.com

=head2 scrub_date_version

 $scrubbed_text = Test::STD::Scrub->scrub_date_version($script_text)

When comparing the contents of two Perl program modules, 
the date and version should not be used 
in the comparision. 
The I<scrub_date_ticket> method will replace
the date and version with a generic value.
Applying the I<scrub_date_ticket> to the contents
of both files before the comparision will 
eliminate the date and version as factors in
the comparision.

For example,

 ==> $text

 $VERSION = \'0.01\';
 $DATE = \'2003/06/07\';

 ==> Test::STD::Scrub->scrub_date_version($text)

 $VERSION = '0.00;
 $DATE = 'Feb 6, 1969';

=head2 scrub_file_line

 $scrubbed_text = Test::STD::Scrub->scrub_file_line($script_text)

When comparing the ouput of I<Test> module
the file and line number should not be used 
in the comparision. 
The I<scrub_file_line> method will replace
the file and line with a generic value.
Applying the I<scrub_file_line> to the contents
of both files before the comparision will 
eliminate the file and line as factors in
the comparision.

For example,

 ==> $text 

 ok 2 # (E:/User/SoftwareDiamonds/installation/t/Test/STDmaker/tgA1.t at line 123 TODO?!)';

 ==> Test::STD::Scrub->scrub_file_line($text)

 ok 2 # (xxxx.t at line 000 TODO?!)

=head2 scrub_test_file

 $scrubbed_text = Test::STD::Scrub->scrub_test_file($script_text)

When comparing the ouput of I<Test:Harness> module
the test file should not be used 
in the comparision. 
The I<scrub_test_file> method will replace
the test file with a generic value.
Applying the I<scrub_test_file> to the contents
of both files before the comparision will 
eliminate the test file as a factor in
the comparision.

For example,

 ==>$text

 Running Tests\n\nE:/User/SoftwareDiamonds/installation/t/Test/STDmaker/tgA1.1..16 todo 2 5;

 ==> Test::STD::Scrub->scrub_test_file($text)

 Running Tests xxx.t 1..16 todo 2 5;

=head1 NOTES

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