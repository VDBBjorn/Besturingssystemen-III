#use strict;
use Win32::OLE qw(in with);

while ((my $key,my $value)=each %INC) {
   print "\$INC{$key} = $value\n";
}


