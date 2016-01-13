sub bepaal_klassen{
    $contname=shift;
    $obj=bind_object($contname);

my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                       # mag je niet vergeten
my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
   $ADOcommand->{ActiveConnection}      = $ADOconnection;        # verwijst naar het voorgaand object
   $ADOcommand->{Properties}->{"Page Size"} = 20;

my $sBase  = $obj->{adspath};
my $sFilter     = "(objectcategory=*)";
my $sAttributes = "objectclass";
my $sScope      = "subtree";
   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";

   my $ADOrecordset = $ADOcommand->Execute();
   until ( $ADOrecordset->{EOF} ) {
         $klasse=pop @{$ADOrecordset->Fields("objectclass")->{Value}};    #enkel laatste waarde
         $classes{$klasse}=$classes{$klasse}+1;
         $ADOrecordset->MoveNext();
    }
    $n = scalar(keys %classes);
    print "\n\n$n verschillende klassen in $contname\n";
    print_geordend();
    %classes=();   #hash opkuisen

   $ADOrecordset->Close();
   $ADOconnection->Close();
}


