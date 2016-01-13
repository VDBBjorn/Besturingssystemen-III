#dsquery * "dc=iii,dc=hogent,dc=be" 
#           -filter "(&(objectcategory=person)(UserAccountControl:1.2.840.113556.1.4.803:=32))" 
#           -attr cn UserAccountControl

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

my $RootDSE=bind_object("RootDSE"); #serverless Binding
   $RootDSE->getinfo();

$domein=bind_object($RootDSE->{defaultNamingContext});
my $sBase       = $domein->{adspath};
my $sFilter     = "(&(objectcategory=person)(UserAccountControl:1.2.840.113556.1.4.803:=32))";
my $sAttributes = "cn,UserAccountControl,AdsPath";
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
   $ADOcommand->{Properties}->{"Sort On"} = "cn";

   my $ADOrecordset = $ADOcommand->Execute();
   printf "\n %25s\t%20s\t%s", "Naam","UserAccountControl","Passwordrequired\n";
   until ( $ADOrecordset->{EOF} ) {
         $waarde=$ADOrecordset->Fields("UserAccountControl")->{Value};
         $user=bind_object($ADOrecordset->Fields("AdsPath")->{Value});
         printf "\n %25s\t%20s\t%15s", $user->{cn},$waarde,$user->{Passwordrequired};
         $ADOrecordset->MoveNext();
    }

   $ADOrecordset->Close();
   $ADOconnection->Close();



