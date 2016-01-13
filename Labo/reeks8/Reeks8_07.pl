#. . . implementatie functie bind_object zie sectie 5 in reeks 6
use Win32::OLE::Const "Active DS Type Library";
my $RootObj=bind_object("RootDSE"); #serverless Binding
   $RootObj->getinfo();

my $cont=bind_object("ou=...,ou=...,ou=labo,".$RootObj->{defaultNamingContext}); # vul in
$cont->{filter}=["user"];                   # enkel users in de container

foreach (in $cont) {
   print "mail(" . $_->Get("cn") . ") is ";
   print $_->{mail} || "not set";
   print  "\n\tgeef nieuw mail-adres: ";
   chomp(my $nmail=<>);
   $nmail ? $_->Put("mail",$nmail)  # ook mogelijk om het ADSI-attribuut te gebruiken:
                                    # $_->{EmailAddress} = $nmail
                                    # of met PutEx en update
                                    # $_->PutEx(ADS_PROPERTY_UPDATE,"mail",[$nmail]);
          : $_->PutEx(ADS_PROPERTY_CLEAR,"mail",[]); # geen equivalent mogelijk met het ADSI-attribuut
   $_->SetInfo();
}



