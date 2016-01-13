use Win32::OLE qw(in);
use Win32::OLE::Const "Active DS Type Library";  #bibliotheek inladen

my $dso = Win32::OLE->GetObject("LDAP:")   ;

#voor ugent.be
my $loginnaam="....\@UGENT.BE";  #vul aan met je UGent-loginaccount
my $paswoord="...";    #vul in

my $moniker = "LDAP://ugentdc1.ugent.be:636/CN=UGENTDC1,OU=Domain Controllers,DC=ugent,DC=be";
my $obj=$dso->OpenDSObject($moniker,$loginnaam,$paswoord,ADS_USE_SSL + ADS_SERVER_BIND);
print (Win32::OLE->LastError()?"not oke":"oke"),"\n";

#voor iii.hogent.be
my $loginnaam = ".....";         #vul in
my $paswoord  = ".....";         #vul in

my $moniker="LDAP://193.190.126.71/CN=Satan,OU=Domain Controllers,DC=iii,DC=hogent,DC=be";
my $obj = $dso->OpenDSObject($moniker, $loginnaam, $paswoord, ADS_SECURE_AUTHENTICATION);
print (Win32::OLE->LastError()?"not oke":"oke"),"\n";


