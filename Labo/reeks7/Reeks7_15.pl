#dsquery * "cn=Schema,cn=configuration,dc=iii,dc=hogent,dc=be"  
#         -filter "(&(objectCategory=attributeSchema) 
#                  (|(searchFlags:1.2.840.113556.1.4.803:=1)(systemFlags:1.2.840.113556.1.4.804:=5)))" 
#         -attr cn systemFlags SearchFlags


#. . . 'implementatie bind_object functie: zie reeks 6, sectie 5
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


my $sBase       =  $schema->{adspath};
my $sFilter     = "(&(objectCategory=attributeSchema)"
                . "(|(searchFlags:1.2.840.113556.1.4.803:=1)"
                  . "(systemFlags:1.2.840.113556.1.4.804:=5)))";
my $sAttributes = "cn,searchFlags,systemFlags";
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand->{Properties}->{"Sort On"} = "cn";

my $ADOrecordset = $ADOcommand->Execute();
until ( $ADOrecordset->{EOF} ) {
     my $prefix  = $ADOrecordset->Fields("searchFlags")->{Value} & 1 ? "I "  : "  ";
        $prefix .= $ADOrecordset->Fields("systemFlags")->{Value} & 1 ? "NR " : "   ";
        $prefix .= $ADOrecordset->Fields("systemFlags")->{Value} & 4 ? "C "  : "  ";
        print $prefix , $ADOrecordset->Fields("cn")->{Value} , "\n";
        $ADOrecordset->MoveNext();
   }
$ADOrecordset->Close();
$ADOconnection->Close();

#opmerking: je kan ook de constanten ophalen uit de library
use Win32::OLE::Const "Active DS Type Library";  #bibliotheek inladen

my $sFilter     = "(&(objectCategory=attributeSchema)"
                . "(|(searchFlags:1.2.840.113556.1.4.803:=1)"
                . "(systemFlags:1.2.840.113556.1.4.804:="
                .(ADS_SYSTEMFLAG_ATTR_NOT_REPLICATED+ADS_SYSTEMFLAG_ATTR_IS_CONSTRUCTED)."))";



