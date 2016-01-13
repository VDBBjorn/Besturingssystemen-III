use Win32::OLE qw(in);

my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = ". . . "; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = ". . . "; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                       # mag je niet vergeten
my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
   $ADOcommand->{ActiveConnection}      = $ADOconnection;        # verwijst naar het voorgaand object
   $ADOcommand->{Properties}->{"Page Size"} = 20;

my $RootDSE=bind_object("RootDSE"); #serverless Binding
   $RootDSE->getinfo();

my $domein  = bind_object( $RootDSE->Get("defaultNamingContext") );
my $sBase  = $domein->{adspath};

my $sFilter     = ""; #mag leeg zijn
#my $sFilter    = "(objectClass=user)";  #enkel users
#my $sFilter    = "(objectClass=u*)";    #lukt niet met wildcards
#my $sFilter    = "((distinguishedName=*) #lukt wel
#my $sFilter    = "((distinguishedName=CN=*) #lukt niet meer
#my $sFilter    = "(cn=*an*)";            #lukt wel met wildcards
#my $sFilter    = "(cn=*)";               #attribuut cn moet ingesteld zijn

my $sAttributes ="*";
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand->{Properties}->{"Sort On"} = "cn";

my $ADOrecordset = $ADOcommand->Execute();


print "\n",$ADOrecordset->{RecordCount}," AD-objecten \n";
   $ADOrecordset->Close();
   $ADOconnection->Close();



