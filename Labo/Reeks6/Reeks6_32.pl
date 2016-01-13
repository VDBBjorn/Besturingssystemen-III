# implementatie bind_object functie: zie sectie 5

my $rootDSE = bind_object("rootDSE");
my $reeelSchema  = bind_object( $rootDSE->Get("schemaNamingContext") );

my %reeel;
foreach (in $reeelSchema){
    $reeel{$_->{class}}++;
}

while (($type,$aantal)=each %reeel){
    print $type,"\t",$aantal,"\n";
}



