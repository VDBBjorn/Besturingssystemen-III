#dsquery * "dc=iii,dc=hogent,dc=be" 
#      -filter "(objectCategory=CN=Person,CN=Schema,CN=Configuration,DC=iii,DC=hogent,DC=be)" 
#      -attr objectclass objectCategory

#Net als in oefening 8 kan je in de filter het wildcard-teken maar beperkt gebruiken omdat het LDAP-attribuut 
#objectCategory van het "syntaxtype" DN is. 
#Volgende dsquery lukt dus NIET

#dsquery * "dc=iii,dc=hogent,dc=be" -filter "(objectCategory=*Person*)" -attr objectclass objectCategory

#Er is wel een handig alternatief (zie ook MSDN library - verwijzing in oefening 8). 
#Voor het LDAP-attribuut "objectCategory" kan je als 'zoekwaarde' de "ldapdisplayName" opgeven van de klasse 
#die ingesteld wordt. De bovenstaande dsquery kan dus worden ingekort met:

#dsquery * "dc=iii,dc=hogent,dc=be" -filter "(objectCategory=person)" -attr objectclass objectCategory

#analoog voor DnsNode:
#dsquery * "dc=iii,dc=hogent,dc=be" -filter "(objectCategory=DnsNode)" -attr objectclass objectCategory

use Win32::OLE 'in';
$Win32::OLE::Warn = 3;
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

my $schema  = bind_object( $RootDSE->Get("schemaNamingContext") );

my $sBase  = $schema->{adspath};

my $sAttributes = "adspath,cn,objectCategory,objectclass";
my $sScope      = "subtree";

   $ADOcommand->{Properties}->{"Sort On"} = "cn";

foreach my $classnaam (in @ARGV) {
    print "\nObjectcategory \t",$classnaam;
    print "\n*************************************************";
    print "\nclass (singlevalued)  \tobjectclass (multivalued)\tobjectCategory";

    my $sFilter = "(objectcategory=$classnaam)";
    $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
    my $ADOrecordset = $ADOcommand->Execute();
    until ( $ADOrecordset->{EOF} ) {
           $object=bind_object($ADOrecordset->Fields("adspath")->{Value});
           print "\n",$object->{class},"\t";
           print join ",",@{$ADOrecordset->Fields("objectclass")->{Value}};           #is multivalued
           print "\n\t",$ADOrecordset->Fields("objectCategory")->{Value};        
           $ADOrecordset->MoveNext();
    }
    $ADOrecordset->Close();
    print "\n";
}
$ADOconnection->Close();




