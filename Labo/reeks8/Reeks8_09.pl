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
   $sBase .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III");        # als je niet in het domein zelf zit
   $sBase .= $RootObj->{defaultNamingContext};

my $sFilter     = "(objectcategory=group)";
my $sAttributes = "cn,groupType";
my $sScope      = "subtree";

   $ADOcommand->{Properties}->{"Sort On"} = "groupType";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
my $ADOrecordset = $ADOcommand->Execute();

until ( $ADOrecordset->{EOF} ) {
    printf "%04b\t%s\n",$ADOrecordset->Fields("groupType")->{Value}   # eerste bit staat op 1
                       ,$ADOrecordset->Fields("cn")->{Value};
    $ADOrecordset->MoveNext();
}
$ADOrecordset->Close();
$ADOconnection->Close();



