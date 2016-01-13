#. . . implementatie functie bind_object: zie reeks 6, oefening 4
#. . . implementatie functie valueattribuut: zie oefening 1
my $RootObj=bind_object("RootDSE"); #serverless Binding
   $RootObj->getinfo();

my $cont=bind_object("ou=...,ou=...,ou=labo,".$RootObj->{defaultNamingContext}); # vul in
my $usernaam="user_. . .";  # vul in max 20 tekens

foreach (in $cont) {
        $_->GetInfoEx(["canonicalName"],0);
        $_->Get("canonicalName") =~ m[.*/(.*)$];
        lc($1) ne lc($usernaam) or die "SPN moet uniek zijn !!"
}

my $samnaam=$usernaam;

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
my $sFilter     = "(&(samAccountName=$samnaam)(|(objectcategory=group)(objectcategory=computer)(objectcategory=person)))";
my $sAttributes = "samAccountName";
my $sScope      = "subtree";

   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
my $ADOrecordset = $ADOcommand->Execute();

$ADOrecordset->{EOF} or die "Samnaam moet uniek zijn !!";
$ADOrecordset->Close();
$ADOconnection->Close();

my $user=$cont->Create("user", "cn=$usernaam");
$user->Put("samAccountName",$samnaam);
$user->SetInfo();
print "toegevoegd met adspath: $user->{adspath}\n"
     unless (Win32::OLE->LastError());

$user->GetInfo();

printf "%20s is ingesteld op %s\n",$_,join ("
                                     ",@{valueattribuut($user,$_)})
     foreach in bind_object($user->{schema})->{MandatoryProperties};



