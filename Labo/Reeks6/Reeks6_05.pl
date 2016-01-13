use Win32::OLE qw(in);
use Win32::OLE::Const "Active DS Type Library";  #bibliotheek inladen
$Win32::OLE::Warn = 3;

$moniker_thuis="LDAP://193.190.126.71/CN=Satan,OU=Domain Controllers,DC=iii,DC=hogent,DC=be";
$obj=bind_object($moniker_thuis);
print (Win32::OLE->LastError()?"not oke":"oke"),"\n";

$distinguishedName="CN=Satan,OU=Domain Controllers,DC=iii,DC=hogent,DC=be";
$obj=bind_object($distinguishedName);
print (Win32::OLE->LastError()?"not oke":"oke"),"\n";

sub bind_object{
   my $parameter=shift;
   my $moniker;
   if ( uc($ENV{USERDOMAIN}) eq "III") { #ingelogd op het III domein
       $moniker = (uc( substr( $parameter, 0, 7) ) eq "LDAP://" ? "" : "LDAP://").$parameter;
       return (Win32::OLE->GetObject($moniker));
   }
   else {                                #niet ingelogd
       my $ip="193.190.126.71";          #voor de controle thuis
       $moniker = (uc( substr( $parameter, 0, 7) ) eq "LDAP://" ? "" : "LDAP://$ip/").$parameter;
       my $dso = Win32::OLE->GetObject("LDAP:");
       my $loginnaam = ".....";          #vul in
       my $paswoord  = ".....";          #vul in
       return ($dso->OpenDSObject( $moniker, $loginnaam, $paswoord, ADS_SECURE_AUTHENTICATION ));
  }
}


