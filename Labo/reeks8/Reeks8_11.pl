#. . . implementatie functie bind_object zie sectie 5 in reeks 6
#. . . implementatie functie valueattribuut: zie oefening 1

my $RootObj=bind_object("RootDSE"); #serverless Binding
   $RootObj->getinfo();

my $cont=bind_object("ou=...,ou=...,ou=labo,".$RootObj->{defaultNamingContext});

my $groepnaam="groep";  # vul in naar keuze

foreach (in $cont) {
        $_->GetInfoEx(["canonicalName"],0);
        $_->Get("canonicalName") =~ m[.*/(.*)$];
        lc($1) ne lc($groepnaam) or die "RDN moet uniek zijn !!"
}

my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                       # mag je niet vergeten
my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
   $ADOcommand->{ActiveConnection}      = $ADOconnection;        # verwijst naar het voorgaand object
   $ADOcommand->{Properties}->{"Page Size"} = 20;

my $sBase  = "LDAP://";
   $sBase .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III");        # als je niet in het domein zelf zit
   $sBase .= $RootObj->{defaultNamingContext};
my $sFilter     = "(&(samAccountName=$groepnaam*)(|(objectcategory=group)(objectcategory=computer)(objectcategory=person)))";
my $sAttributes = "samAccountName";
my $sScope      = "subtree";

   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
my $ADOrecordset = $ADOcommand->Execute();

my %lijst;
until ( $ADOrecordset->{EOF} ) {
    $lijst{$ADOrecordset->Fields("samAccountName")->{Value}}=1;
    $ADOrecordset->MoveNext();
}
$ADOrecordset->Close();
$ADOconnection->Close();

do {
  $samnaam=sprintf("%s%02d",lc($groepnaam),++$tel);
} while $lijst{$samnaam};

my $groep=$cont->Create("group", "cn=$groepnaam");
$groep->Put("samAccountName",$samnaam);
$groep->SetInfo();
print "toegevoegd met adspath: $groep->{adspath}\n"
     unless (Win32::OLE->LastError());

$groep->GetInfo();

printf "%20s is ingesteld op %s\n",$_,join ("
                                     ",@{valueattribuut($groep,$_)})
     foreach in bind_object($groep->{schema})->{MandatoryProperties};


