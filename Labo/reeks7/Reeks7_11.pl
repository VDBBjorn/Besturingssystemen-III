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

my $student ="....,OU=Studenten,ou=iii,".$RootDSE->{defaultNamingContext}; #vul aan
my $studentObject = bind_object($student);
my $primaireGroep = $studentObject->get("primaryGroupID");

my $schema  = bind_object( $RootDSE->Get("schemaNamingContext") );
my $sBase  = $schema->{adspath};

#alle groepen ophalen
my $sFilter     = "(objectclass=group)";#(primaryGroupToken=$primaireGroep) lukt niet want geconstrueerd attribuut
my $sAttributes =" primaryGrouptoken,cn";
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand->{Properties}->{"Sort On"} = "cn";

my $ADOrecordset = $ADOcommand->Execute();

my $groepName="";
while ($groepName eq "" && !$ADOrecordset->{EOF}) { 
  my $primaryGroupToken = $ADOrecordset->Fields("primaryGrouptoken")->{Value};
  if ($primaryGroupToken == $primaireGroep) {
    $groepName=$ADOrecordset->Fields("cn")->{Value};
  }
  $ADOrecordset->MoveNext();
}

print $groepName;

   $ADOrecordset->Close();
   $ADOconnection->Close();



