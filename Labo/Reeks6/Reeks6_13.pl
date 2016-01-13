# implementatie bind_object functie: zie sectie 5
my $RootObj = bind_object("RootDSE");

printf "%-10s : %s\n", $_ , $RootObj->{$_} foreach qw (Name Class GUID ADSPath Parent Schema defaultNamingContext dnsHostName); 
#De ADSI-attributen Class en Schema zijn niet ingevuld omdat RootDSE niet overeenkomt met een AD object
#verwissel defaultNamingContext dnsHostName om alle uitvoer te zien.

#In PowerShell heb je daar geen last van...

