# implementatie bind_object functie: zie sectie 5

my $AdsPath = "OU=EM7INF,OU=Studenten,OU=iii,DC=iii,DC=hogent,DC=be";
my $obj     = bind_object($AdsPath);
print "--------------------ADSI-------------------------------\n";
print  "Adspath (ADSI) = " ;
printinhoud ($obj->{ADsPath});

print  "class (ADSI)   = ";
printinhoud ($obj->{class});

print  "GUID (ADSI)    = ";
printinhoud ($obj->{GUID});

print "--------------------LDAP-------------------------------\n";
print  "distinguishedName (LDAP) = " ;
printinhoud ($obj->{distinguishedName});

print  "objectclass (LDAP)       = ";
printinhoud ($obj->{objectclass});

print  "objectGUID (LDAP)        = ";
printinhoud (sprintf ("%*v02X ","",$obj->{objectGUID}));

sub printinhoud{
   my $inhoud=shift;
   if (ref $inhoud) {
       print "Array met " , scalar @{$inhoud} , " elementen :\n\t" ;
       print join("\n\t", @{$inhoud});
   }
   else {
       print "$inhoud";
   }
   print "\n";
}

#In Powershell - interpretatie van de bitstring gebeurt automatisch
$adObject | select "adspath","class","distinguishedName","objectclass","objectGUID"


