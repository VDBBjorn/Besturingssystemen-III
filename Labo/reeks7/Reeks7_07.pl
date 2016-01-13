#dsquery * "OU=studenten,OU=iii,dc=iii,dc=hogent,dc=be" -filter "(PostalCode=9070)" -attr cn streetAddress l

use Win32::OLE qw(in);

@ARGV == 1 or die  "geef de postcode als enig argument !\n";

my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                       # mag je niet vergeten
my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
   $ADOcommand->{ActiveConnection}      = $ADOconnection;        # verwijst naar het voorgaand object
   $ADOcommand->{Properties}->{"Page Size"} = 20;

my $RootDSE=bind_object("RootDSE"); #serverless binding
   $RootDSE->getinfo();

my $postcode = $ARGV[0];

my $sBase  = "LDAP://";
   $sBase .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III") ; # als je niet in het domein zelf zit
   $sBase .= "OU=studenten,OU=iii,". $RootDSE->{defaultNamingContext};
my $sFilter     = "(&(objectCategory=person)(objectclass=user)(postalCode=$postcode))";
#Omdat enkel voor users het attribuut postalCode ingesteld is volstaat de filter eventueel met wildcard
#my $sFilter     = "(postalCode=$postcode*)";

my $sAttributes = "cn,streetAddress,l";
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand->{Properties}->{"Sort On"} = "l"; 

my $ADOrecordset = $ADOcommand->Execute();
print "\n",$ADOrecordset->{RecordCount}," AD-objecten: \n";
until ( $ADOrecordset->{EOF} )  {
   printf "%-25s %s %s\n",$ADOrecordset->Fields("cn")->{Value}
                         ,$ADOrecordset->Fields("streetAddress")->{Value}
                         ,$ADOrecordset->Fields("l")->{Value};
   $ADOrecordset->MoveNext();
}
   $ADOrecordset->Close();
   $ADOconnection->Close();


