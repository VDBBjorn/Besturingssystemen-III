#. . . implementatie functie bind_object zie sectie 5 in reeks 6
#. . . implementatie functie valueattribuut: zie oefening 1

my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                       # mag je niet vergeten

   my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
   $ADOcommand->{ActiveConnection}      = $ADOconnection; # verwijst naar het voorgaand object
   $ADOcommand->{Properties}->{"Page Size"} = 20;
 
   my $RootObj=bind_object("RootDSE"); #serverless Binding
   $RootObj->getinfo();
 
   my $sBase  = "LDAP://";
   $sBase .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III"); # als je niet in het domein zelf zit
   $sBase .= $RootObj->{defaultNamingContext};
   my $sFilter     = "(&(objectcategory=person)(objectclass=user))"; #alle users ophalen
   my $sAttributes = "adspath,samAccountName";
   my $sScope      = "subtree";
 
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   my $ADOrecordset = $ADOcommand->Execute();
 
   my %lijst;
   until ( $ADOrecordset->{EOF} ) {
     $lijst{lc($ADOrecordset->Fields("samaccountname")->{Value})}
       =$ADOrecordset->Fields("adspath")->{Value};
     $ADOrecordset->MoveNext();
   }
 
   $ADOrecordset->Close();
 
   #inlezen naam user
   $tel=0;
   printf "%-20s%s", $_, ++$tel%4 ? "" : "\n" foreach sort keys %lijst;
   print "\n";
   my $user;
   do {
     print "Kies een user: ";
     chomp($user=<STDIN>);
   } until $lijst{lc($user)};
   
   
   $adspath = $lijst{lc($user)};
   #bijhorend AD-object
   my $ADobject = bind_object($adspath);;
   
   #primaire groep - groupID ophalen
   my $primaryGroupID = $ADobject->get("primaryGroupID");
   
   #bijhorende groep zoeken
   my $sFilter     = "(objectclass=group)"; #alle groepen ophalen - het ldap-attribuut primaryGroupToken is geconstrueerd en kan je dus niet in de filter opnemen
   my $sAttributes = "primaryGroupToken,samAccountName";
   
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   my $ADOrecordset = $ADOcommand->Execute();
   my $primaryGroup="";
   my %lijst;
   until ( $ADOrecordset->{EOF} ) {
     $groepnr =$ADOrecordset->Fields("primaryGroupToken")->{Value};
     $primaryGroup = $ADOrecordset->Fields("samaccountname")->{Value} if ($groepnr eq $primaryGroupID);
     $ADOrecordset->MoveNext();
   }
   
   $ADOrecordset->Close();

$ADOconnection->Close();

print  "Primaire groep: ",$primaryGroup,"\n";
  
#alle andere groepen
print "Behoort tot groepen: ",join(",",@{$ADobject->getEx("memberOf")}),"\n";
  
#of met IADsUser-methode
#print "Behoort tot groepen: ",join ("   ",sort map {$_->{name}} in $ADobject->{Groups});



