use Win32::OLE qw(in);

sub bind_object{
   my $moniker=shift;
#   print "Moniker : $moniker\n";
   my $obj = Win32::OLE->GetObject($moniker);
   return $obj;
}

my $obj=bind_object ("LDAP://CN=Satan,OU=Domain Controllers,DC=iii,DC=hogent,DC=be");
print (Win32::OLE->LastError()?"not oke":"oke"),"\n";

$obj=bind_object ("LDAP://iii.hogent.be/CN=Satan,OU=Domain Controllers,DC=iii,DC=hogent,DC=be");
print (Win32::OLE->LastError()?"not oke":"oke"),"\n";

$obj=bind_object("LDAP://Satan.iii.hogent.be/CN=Astaroth,OU=Domain Controllers,DC=iii,DC=hogent,DC=be");
print (Win32::OLE->LastError()?"not oke":"oke"),"\n";

$obj=bind_object("LDAP://CN=Belial,OU=Domain Controllers,DC=iii,DC=hogent,DC=be");
print (Win32::OLE->LastError()?"not oke":"oke"),"\n";

$obj=bind_object("LDAP://192.168.16.16/CN=Belial,OU=Domain Controllers,DC=iii,DC=hogent,DC=be");
print (Win32::OLE->LastError()?"not oke":"oke"),"\n";


