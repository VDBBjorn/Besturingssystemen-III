$RootObj = bind_object("RootDSE");
my $cont = bind_object("OU=Studenten,OU=iii,".$RootObj->get(defaultNamingContext));

print $cont->{PropertyCount}, " properties in Property Cache\n";
$cont->getInfo();
print $cont->{PropertyCount}, " properties in Property Cache\n";
$cont->getInfoEx(["ou","canonicalName","msDS-Approx-Immed-Subordinates","objectclass"],0);
print $cont->{PropertyCount}, " properties in Property Cache\n";


