# implementatie bind_object functie: zie sectie 5

#serverless binding
my $RootObj = bind_object("RootDSE");

my $cont = bind_object("OU=Studenten,OU=iii,".$RootObj->get(defaultNamingContext));

print "Groepen:\n";
$cont->{Filter} = ["organizationalUnit"];
foreach my $subcont (in $cont) {
    # het betreft een geconstrueerd LDAP-attribuut !
    $subcont->GetInfoEx(["ou","msDS-Approx-Immed-Subordinates"],0);
    $waarde=$subcont->Get("msDS-Approx-Immed-Subordinates");
    printf "% 7s: %d\n" ,$subcont->{ou}, $waarde;
}

