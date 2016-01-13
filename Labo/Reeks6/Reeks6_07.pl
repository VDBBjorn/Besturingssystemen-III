# implementatie bind_object functie: zie sectie 5

# gebruik je eigen naam in dit AdsPath
my $obj = bind_object("CN=. . .,OU=EM7INF,OU=Studenten,OU=iii,DC=iii,DC=hogent,DC=be");   


printf "ADSPath = %s\n", $obj->{ADSPath};
#printf "ADSPath = %s\n", $obj->{"ADSPath"}; #beide alternatieven zijn juist

printf "Mail    = %s\n", $obj->{EmailAddress};
#printf "Mail    = %s\n", $obj->{"EmailAddress"};



