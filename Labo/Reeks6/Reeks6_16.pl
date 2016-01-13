#zonder filter - alle computers ophalen uit het domein
dsquery computer "dc=iii,dc=hogent,dc=be" 

#met filter - nog niet echt gezien
dsquery * "dc=iii,dc=hogent,dc=be" -filter "(cn=Hilbert)" -attr adspath  #vervang Hilbert door je eigen computer

# implementatie bind_object functie: zie sectie 5
my $lokaal = $ARGV[0];
my $lokaalContainer=bind_object("OU=$lokaal,OU=PC's,OU=iii,DC=iii,DC=hogent,DC=be");
foreach (in $lokaalContainer){
    print $_->{cn},"\n";
}

#deel2
my $systeemContainer=bind_object("cn=system,dc=iii,dc=hogent,dc=be");
foreach (in $systeemContainer){
    print $_->{cn},":",$_->{class},"\n";
}

#powershell:

$adObject.Children 


