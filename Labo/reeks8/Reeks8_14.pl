#. . . implementatie functie bind_object zie sectie 5 in reeks 6
#. . . implementatie functie valueattribuut: zie oefening 1

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
my $sFilter     = "(&(objectcategory=group)(member=*))";  # enkel groepen die een inhoud hebben voor "member"
my $sAttributes = "samaccountname,member";
my $sScope      = "subtree";

   $ADOcommand->{Properties}->{"Sort On"} = "samaccountname";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
my $ADOrecordset = $ADOcommand->Execute();

my %lijst;
until ( $ADOrecordset->{EOF} ) {
    my $groep=lc($ADOrecordset->Fields("samaccountname")->{Value});
    my $leden=$ADOrecordset->Fields("member")->{Value};
    $lijst{$groep}=$leden;
    printf "%3d leden in $groep\n",scalar @{$leden};
    $ADOrecordset->MoveNext();
}

$ADOrecordset->Close();
$ADOconnection->Close();

my $groep;
do {
  print "Kies een groep: ";
  chomp($groep=<STDIN>);
} until $lijst{lc($groep)};

print "Heeft als leden: ",(join "
                 ",sort map {join "/",reverse ($_ =~ /(?<!DC)=(.*?),/g)} @{$lijst{lc($groep)}});


