# implementatie bind_object functie: zie sectie 5

my $obj = bind_object("CN=. . .,OU=EM7INF,OU=Studenten,OU=iii,DC=iii,DC=hogent,DC=be");   # gebruik je eigen naam in dit AdsPath

#alle gevraagde LDAP-attributen zijn singlevalued en eenvoudig uit te schrijven als string
printf "%-20s : %s\n", $_ , $obj->{$_} foreach qw (mail givenName sn displayName homeDirectory scriptPath profilePath logonHours userWorkstations);

