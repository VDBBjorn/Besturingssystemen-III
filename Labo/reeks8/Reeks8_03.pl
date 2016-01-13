#. . . implementatie functie bind_object zie sectie 5 in reeks 6
#. . . implementatie functie valueattribuut: zie oefening 1

@ARGV >= 1 or die "je moet een ldapdisplayname van een klasse opgeven, vb container, organizationalUnit, ...\n";
my $klassenaam = $ARGV[0];

my $klasse = bind_object( "schema/$klassenaam" );
print "Verplicht attributen van $klassenaam:\n";
!Win32::OLE->LastError()
	or die "je moet een ldapdisplayname van een klasse opgeven, vb container, organizationalUnit, ...\n";
$klasse->{Class} eq "Class"
	or die "je moet een ldapdisplayname van een klasse opgeven, vb container, organizationalUnit, ...\n";

my $tel=0;
my @lijst=in $klasse->{MandatoryProperties};
foreach (@lijst) {
   $tel++;
   print "$tel:\t$_\n";
}

my $nr;
do { print "Kies een nummer <= $tel: ";
     $nr=<STDIN>;
   } until $nr>0 && $nr<=$tel;
$nr--;

my $Ldapdisplayname=$lijst[$nr];
print "\nOverzicht van $Ldapdisplayname:\n";

my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");
   $ADOconnection->{Provider} = "ADsDSOObject";
   $ADOconnection->{Properties}->{"User ID"}          = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar
   $ADOconnection->{Properties}->{"Encrypt Password"} = True;
   $ADOconnection->Open();                                       # mag je niet vergeten
my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");
   $ADOcommand->{ActiveConnection}      = $ADOconnection;        # verwijst naar het voorgaand object
   $ADOcommand->{Properties}->{"Page Size"} = 20;


my $RootObj=bind_object("RootDSE"); #serverless Binding
   $RootObj->getinfo();

my $sBase  = "LDAP://";
   $sBase .= "193.190.126.71/" unless (uc($ENV{USERDOMAIN}) eq "III");     # als je niet in het domein zelf zit
   $sBase .= $RootObj->{defaultNamingContext};
my $sFilter     = "(objectclass=$klassenaam)";
my $sAttributes = "distinguishedname";  #attribuut niet direct ophalen - kan geconstrueerd zijn ???
my $sScope      = "subtree";

   $ADOcommand->{CommandText} = "<$sBase>;$sFilter;$sAttributes;$sScope";
my $ADOrecordset = $ADOcommand->Execute();

until ( $ADOrecordset->{EOF} ) {
    my $object=bind_object($ADOrecordset->Fields("distinguishedname")->{Value});
    print join (";",@{valueattribuut($object,$Ldapdisplayname)}), " ($object->{name})\n"
        if (uc($object->{class}) eq uc($klassenaam));
    $ADOrecordset->MoveNext();
}
$ADOrecordset->Close();
$ADOconnection->Close();



