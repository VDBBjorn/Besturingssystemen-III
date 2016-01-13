# implementatie bind_object functie: zie sectie 5

@attr=("adspath","class","GUID","name","parent","Schema");
my $obj=bind_object("LDAP://193.190.126.71/CN=Satan,OU=Domain Controllers,DC=iii,DC=hogent,DC=be");
#print (Win32::OLE->LastError()?"not oke":"oke"),"\n";

#alle gevraagde ADSI-attributen zijn singlevalued en eenvoudig uit te schrijven als string
foreach (@attr){
  printf "%20s : %s\n",$_,$obj->{$_};
}

#in PowerShell:
$adObject | select "adspath","class","GUID","name","parent","Schema"


