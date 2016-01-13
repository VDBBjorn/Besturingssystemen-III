#dsquery * "ou=pc's,ou=iii,dc=iii,dc=hogent,dc=be" 
#        -filter "(&(objectCategory=computer)(name=*A))" 
#        -attr cn name canonicalname


my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                     # mag je niet vergeten
my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
   $ADOcommand->{ActiveConnection}      = $ADOconnection;    # verwijst naar het voorgaand object
   $ADOcommand->{Properties}->{"Page Size"} = 20;

my $RootDSE=bind_object("RootDSE"); #serverless Binding
   $RootDSE->getinfo();

my $domein  = bind_object( $RootDSE->Get("defaultNamingContext") );
my $sBase  = $domein->{adspath};

my $sFilter     = "(&(objectCategory=computer)(cn=*A))";
#my $sFilter     = "(&(objectCategory=computer)(name=*A))"; #lukt evengoed
#my $sFilter     = "(&(objectCategory=computer)(canonicalname=*A))";    #geeft geen enkel resultaat
my $sAttributes = "cn,canonicalName";
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand->{Properties}->{"Sort On"} = "cn";

use Win32::OLE qw(in);

my $ADOrecordset = $ADOcommand->Execute();
until ( $ADOrecordset->{EOF} ) {
    printf "%-20s %s %s\n",$ADOrecordset->Fields("cn")->{Value}
                          ,$ADOrecordset->Fields("canonicalName")->{Value}->[0];
    $ADOrecordset->MoveNext();
   }
   $ADOrecordset->Close();
   $ADOconnection->Close();


