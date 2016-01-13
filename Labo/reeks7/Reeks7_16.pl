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
   $ADOcommand->{Properties}->{"Sort On"} = "cn";

my $RootDSE = bind_object("RootDSE");
my $schema  = bind_object( $RootDSE->Get("schemaNamingContext") );

my $sBase  = $schema->{adspath};

#zoek alle users van een groep
my $group="CN=beveiliging,OU=Vakken,OU=iii,DC=iii,DC=hogent,DC=be";

#zonder de matching rule - description kan niet opgehaald worden in deze query
my $sFilter = "(distinguishedName=$group)"; #zoek de groep - kan ook zonder LDAP-query
#my $sAttributes = "member"; 
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";

my $ADOrecordset = $ADOcommand->Execute();
until ( $ADOrecordset->{EOF} )  {
   $value=$ADOrecordset->Fields("member")->{Value}; #alle informatie zit in dit multivalued veld
   print join("\n",@{$value});
   $ADOrecordset->MoveNext();
}

#met de matching rule
my $sFilter = "(memberof:1.2.840.113556.1.4.1941:=$group)";
my $sAttributes = "cn,description"; 
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";

my $ADOrecordset = $ADOcommand->Execute();
until ( $ADOrecordset->{EOF} )  {
   print $ADOrecordset->Fields("cn")->{Value},"\t",$ADOrecordset->Fields("description")->{Value}->[0],"\n";;
   $ADOrecordset->MoveNext();
}


#zoek alle groepen van een user - description kan niet opgehaald worden in deze query
my $user="CN=...,OU=EM7INF,OU=Studenten,OU=iii,DC=iii,DC=hogent,DC=be";

#zonder de matching rule
my $sFilter = "(distinguishedName=$user)"; #zoek de user - kan ook zonder LDAP-query
my $sAttributes = "memberof"; 
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand->{Properties}->{"Sort On"} = "cn";

my $ADOrecordset = $ADOcommand->Execute();
until ( $ADOrecordset->{EOF} )  {
   $value=$ADOrecordset->Fields("memberof")->{Value};
   print join("\n",@{$value});
   $ADOrecordset->MoveNext();
}

#met de matching rule
my $sFilter = "(member:1.2.840.113556.1.4.1941:=$user)";
my $sAttributes = "cn,description"; 
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand->{Properties}->{"Sort On"} = "cn";

my $ADOrecordset = $ADOcommand->Execute();
until ( $ADOrecordset->{EOF} )  {
   print "\n", $ADOrecordset->Fields("cn")->{Value},"\t";
   $description=$ADOrecordset->Fields("description")->{Value};
   print join(" ",@{$description}) if ref $description eq "ARRAY";
   $ADOrecordset->MoveNext();
}




