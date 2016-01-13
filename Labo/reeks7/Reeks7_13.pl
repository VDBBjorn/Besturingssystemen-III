#dsquery * "cn=Schema,cn=configuration,dc=iii,dc=hogent,dc=be" 
#         -filter "(&(objectCategory=classSchema)(!(objectClassCategory=1)))" 
#         -attr cn objectClassCategory


use Win32::OLE qw(in);

#. . . 'implementatie bind_object functie: zie reeks 6, sectie 5

my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                       # mag je niet vergeten
my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
   $ADOcommand->{ActiveConnection}      = $ADOconnection;        # verwijst naar het voorgaand object
   $ADOcommand->{Properties}->{"Page Size"} = 20;

my $RootDSE = bind_object("RootDSE"); #serverless binding
my $schema  = bind_object( $RootDSE->Get("schemaNamingContext") );

my $sBase  = $schema->{adspath};
my $sFilter     = "(&(objectCategory=classSchema)(!(objectClassCategory=1)))";
my $sAttributes = "cn,objectClassCategory";
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand->{Properties}->{"Sort On"} = "cn";

my $ADOrecordset = $ADOcommand->Execute();

print "Abstracte klassen:\n";
until ($ADOrecordset->{EOF} ) {
   print "\t" , $ADOrecordset->Fields("cn")->{Value} , "\n"  if( $ADOrecordset->Fields("objectClassCategory")->{Value} == 3 );
   $ADOrecordset->MoveNext();
   }

print "\nHulpklassen:\n";
$ADOrecordset->MoveFirst();
until ( $ADOrecordset->{EOF} )
   {
   print "\t" , $ADOrecordset->Fields("cn")->{Value} , "\n" if( $ADOrecordset->Fields("objectClassCategory")->{Value} != 3 );        
   $ADOrecordset->MoveNext();
   }

   $ADOrecordset->Close();
   $ADOconnection->Close();




