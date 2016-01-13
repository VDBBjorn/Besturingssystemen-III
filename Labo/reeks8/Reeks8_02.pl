#controle met :

#dsquery * cn= ...,ou=...,ou=labo,DC=iii,DC=hogent,DC=be -attr member
#-filter "(&(description=*/11/*)(!(description=1*/11/*))(!(description=3*/11/*))(!(description=2*/11/*)))"

use Win32::OLE::Const "Active DS Type Library"; #inladen constanten voor PutEx

#. . . implementatie functie bind_object: zie reeks 6, oefening 4


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


my $groep=bind_object("cn=...,ou=...,ou=labo,". $RootObj->{defaultNamingContext}); #vul je eigen groep in
$groep->GetInfoEx(["member"],0);
my $descriptionvalue="*2/1*/*0"; #vervang dit door je eigen beschrijving

my $sBase  = "LDAP://";
   $sBase .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III");        # als je niet in het domein zelf zit
   $sBase .= $RootObj->{defaultNamingContext};
my $sFilter     = "(&(description=" . $descriptionvalue . ")(objectclass=user)(objectcategory=person))";
my $sAttributes = "distinguishedName";
my $sScope      = "subtree";

   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
my $ADOrecordset = $ADOcommand->Execute();

my @lijst;
until ( $ADOrecordset->{EOF} ) {
    push @lijst,$ADOrecordset->Fields("distinguishedName")->{Value};
    $ADOrecordset->MoveNext();
}
$ADOrecordset->Close();
$ADOconnection->Close();

$groep->PutEx(ADS_PROPERTY_UPDATE,"member",\@lijst); #ADS_PROPERTY_UPDATE=2
$groep->SetInfo() unless Win32::OLE->LastError();  
print Win32::OLE->LastError(); #na setInfo wordt eventueel een fout gegeven



