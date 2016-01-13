#. . . 'implementatie bind_object functie: zie reeks 6, sectie 5
$Win32::OLE::Warn = 1;

@ARGV == 1 or die "geef als enige argument de ldapname van een attribuut op!\n";
my $attr_name = $ARGV[0];

my $attribuut = bind_object( "schema/" . $attr_name );

!Win32::OLE->LastError()        || die "$attr_name is geen ldapattribuut";
$attribuut->{class}=="Property" || die "$attr_name is geen ldapattribuut";
print "is " , $attribuut->{Multivalued} ? "multi" : "single" , "-valued\n";
print "Adsi-syntax is: " , $attribuut->{Syntax} , "\n";

my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                     # mag je niet vergeten
my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
   $ADOcommand->{ActiveConnection}      = $ADOconnection;    # verwijst naar het voorgaand object
   $ADOcommand->{Properties}->{"Page Size"} = 20;

my $RootDSE = bind_object("RootDSE");
my $schema  = bind_object( $RootDSE->Get("schemaNamingContext") );

my $sBase       = $schema->{adspath};
my $sFilter     = "(&(objectCategory=attributeSchema)(ldapdisplayname=$attr_name))";
my $sAttributes = "searchFlags";
my $sScope      = "onelevel";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";

my $ADOrecordset = $ADOcommand->Execute();
until ( $ADOrecordset->{EOF} ) {
   print "is " , $ADOrecordset->Fields("searchFlags")->{Value} & 1 ? "wel" : "niet" , " geindexeerd\n";
   $ADOrecordset->MoveNext();
   }
$ADOrecordset->Close();
$ADOconnection->Close();



