#zonder filter - alle computers ophalen uit het domein
dsquery computer "ou=Domain Controllers,dc=iii,dc=hogent,dc=be" 

$RootObj = bind_object('RootDSE');
$domein = $RootObj->{defaultNamingContext};


my $container=bind_object("ou=Domain Controllers,$domein");
foreach (in $container){
    print $_->{cn},"\n";
}


