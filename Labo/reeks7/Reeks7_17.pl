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
   $RootDSE->getinfo();

my $schema  = bind_object( $RootDSE->Get("schemaNamingContext") );

my $sBase       = $schema->{adspath};
my $sFilter     = "(&(objectCategory=attributeSchema)(linkID=*)(!(linkID:1.2.840.113556.1.4.804:=1)))";
my $sAttributes = "ldapDisplayName,linkID";
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand->{Properties}->{"Sort On"} = "linkID";

my $ADOforwardset = $ADOcommand->Execute();
until ( $ADOforwardset->{EOF} ) {
   my $sFilter     = "(&(objectCategory=attributeSchema)(linkID="
                        . ($ADOforwardset->Fields("linkID")->{Value} + 1) . "))";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";

   my $ADObackwardset = $ADOcommand->Execute();
   until ( $ADObackwardset->{EOF} ) {
      printf "% 26s\t%s\n",$ADOforwardset->Fields("ldapDisplayName")->{Value}
                          ,$ADObackwardset->Fields("ldapDisplayName")->{Value};
      $ADObackwardset->MoveNext();
   }
   $ADObackwardset->Close();
   $ADOforwardset->MoveNext();
}
$ADOforwardset->Close();
$ADOconnection->Close();



