use Win32::OLE qw(in);

my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                       # mag je niet vergeten
my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
   $ADOcommand->{ActiveConnection}      = $ADOconnection;        # verwijst naar het voorgaand object
   $ADOcommand->{Properties}->{"Page Size"} = 20;

my $RootDSE=bind_object("RootDSE"); #serverless Binding
   $RootDSE->getinfo();

my $domein  = bind_object( $RootDSE->Get("defaultNamingContext") );
my $sBase  = $domein->{adspath};

my $sFilter     = "(name=Jan)"; #maakt niet echt uit, maar geef wel een filter op
#my $sAttributes = ""; #leeg geeft lege Recordset
my $sAttributes = "*"; #haalt enkel het ADSI-attribuut AdsPath op
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand->{Properties}->{"Sort On"} = "cn";

my $ADOrecordset = $ADOcommand->Execute();

print "\n",$ADOrecordset->{RecordCount}," AD-objecten \n";
print "\n",$ADOrecordset->{Fields}->{Count}," properties :";

foreach my $field (in $ADOrecordset->{Fields}) {
   print "\n\t$field->{name}($field->{type})";
 }



