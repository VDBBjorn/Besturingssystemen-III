#. . . implementatie functie bind_object zie sectie 5 in reeks 6

my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                       # mag je niet vergeten
my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
   $ADOcommand->{ActiveConnection}      = $ADOconnection;        # verwijst naar het voorgaand object
   $ADOcommand->{Properties}->{"Page Size"} = 20;

my $RootObj=bind_object("RootDSE"); #serverless Binding
   $RootObj->getinfo();

my $sBase  = "LDAP://";
   $sBase .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III");    # als je niet in het domein zelf zit
   $sBase .= $RootObj->{defaultNamingContext};

my $sFilter     =  "(&(objectclass=user)(samAccountName=*))";
my $sAttributes = "samAccountName,objectcategory";
my $sScope      = "subtree";

   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
my $ADOrecordset = $ADOcommand->Execute();

my $maxLength;
until ( $ADOrecordset->{EOF} ) {
    $samName=$ADOrecordset->Fields("samAccountName")->{Value};
    $maxLength=length($samName) if (length($samName)>$maxLength);
    print "$samName\n";
    $ADOrecordset->MoveNext();
}
$ADOrecordset->Close();
$ADOconnection->Close();

print "Maximale lengte is $maxLength\n";



