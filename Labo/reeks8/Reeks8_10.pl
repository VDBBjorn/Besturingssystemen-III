use Win32::OLE 'in';
use Win32::OLE::Const "Active DS Type Library";

my @gtype=(ADS_GROUP_TYPE_GLOBAL_GROUP,ADS_GROUP_TYPE_DOMAIN_LOCAL_GROUP ,ADS_GROUP_TYPE_UNIVERSAL_GROUP);
my @zoek=("Globale Beveiligingsgroep","Locale Beveiligingsgroep","Universele Beveiligingsgroep",
          "Globale Distributiegroep" ,"Locale Distributiegroep" ,"Universale Distributiegroep");
print $_+1,": $zoek[$_]\n" foreach 0..$#zoek;

do {
  print "Geef nummer: ";
  chomp($nr=<STDIN>);
} while ($nr>@zoek || $nr<1);
$nr--;

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

my $sFilter     = "(&(&(objectcategory=group)(groupType:1.2.840.113556.1.4.803:=" . $gtype[$nr%3];
   $sFilter    .= $nr<3 ? ")(" : ")(!";
   $sFilter    .= "(groupType:1.2.840.113556.1.4.803:=" . ADS_GROUP_TYPE_SECURITY_ENABLED . "))))";
my $sAttributes = "samAccountName,grouptype";
my $sScope      = "subtree";

   $ADOcommand->{Properties}->{"Sort On"} = "samAccountName";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
my $ADOrecordset = $ADOcommand->Execute();

print "Overzicht $zoek[$nr]en:\n";

until ( $ADOrecordset->{EOF} ) {
    printf "\t%04b\t%s\n",$ADOrecordset->Fields("groupType")->{Value}%16    # 4 laagste bits
                         ,$ADOrecordset->Fields("samAccountName")->{Value};
    $ADOrecordset->MoveNext();
}
$ADOrecordset->Close();
$ADOconnection->Close();



