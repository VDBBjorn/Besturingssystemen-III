use Win32::OLE qw(in); #vermeld expliciet de in-functie

$conf = Win32::OLE->new("CDO.Configuration");
print $conf->{Fields}->{Count}," objecten\n";

$object = $conf->{Fields}->Item(0);
print "\n",join(" / ",Win32::OLE->QueryObjectType($object));


OF
use Win32::OLE qw(in);
$mail = Win32::OLE->new("CDO.Message");
print $mail->{Configuration}->{Fields}->{Count}," objecten\n";

#Alle objecten overlopen uit de Fields-collectie
foreach (in $mail->{Configuration}->{Fields}){
    print "\n",join(" / ",Win32::OLE->QueryObjectType($_));
}


