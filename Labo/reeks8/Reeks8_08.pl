#. . . implementatie functie bind_object zie sectie 5 in reeks 6
#. . . implementatie functie valueattribuut: zie oefening 1

use Win32::OLE::Const "Active DS Type Library";
$Win32::OLE::Warn = 1;

my $RootObj=bind_object("RootDSE"); #serverless Binding
   $RootObj->getinfo();

my $cont=bind_object("ou=...,ou=...,ou=labo,".$RootObj->{defaultNamingContext});
$cont->{filter}=["user"];                   # enkel users in de container

foreach my $user (in $cont) {
   $user->GetInfo();
   $cn=$user->GetPropertyItem("cn", ADSTYPE_CASE_IGNORE_STRING);
   $mail=$user->GetPropertyItem("mail", ADSTYPE_CASE_IGNORE_STRING);
   print "mail(" . $cn->{Values}->[0]->GetObjectProperty(ADSTYPE_CASE_IGNORE_STRING) . ") is ";
   print $mail ? $mail->{Values}->[0]->GetObjectProperty(ADSTYPE_CASE_IGNORE_STRING)
               : "not set";
   print  "\n\tgeef nieuw mail-adres: ";
   chomp(my $waarde=<>);
   if ($mail) {         # was reeds ingesteld
	if  ($waarde) { # moet gewijzigd worden
	   $mail->{ControlCode}=ADS_PROPERTY_UPDATE;
           $mail->{Values}->[0]->PutObjectProperty(ADSTYPE_CASE_IGNORE_STRING,$waarde);
	   }
 	else {          # moet verwijderd worden
	   $mail->{ControlCode} = ADS_PROPERTY_CLEAR;
           }
        }
   else {               # was niet ingesteld
	if  ($waarde) { # moet ingesteld worden
	   $mail=$cn;   # PropertyItem cn als sjabloon gebruiken voor PropertyItem mail
	   $mail->{Name}="mail";
	   $mail->{ControlCode}=ADS_PROPERTY_APPEND;
           $mail->{Values}->[0]->PutObjectProperty(ADSTYPE_CASE_IGNORE_STRING,$waarde);
	   }
      }
   $user->PutPropertyItem($mail);
   $user->Setinfo();
}


