# implementatie bind_object functie: zie sectie 5

@ARGV == 1 or die "Geef de ldapDisplayName van een klasse op als argument !\n";
my $argument=$ARGV[0];

my $abstracteKlasse  = bind_object( "schema/$argument" );
@attributen = qw(OID AuxDerivedFrom Abstract Auxiliary PossibleSuperiors MandatoryProperties
                 OptionalProperties Container Containment);

foreach my $prefix (@attributen){
    my $attribuut = $abstracteKlasse->{$prefix};
    printlijn( \$prefix, $_ ) foreach ref $attribuut eq "ARRAY" ? @{$attribuut} : $attribuut;
}

sub printlijn {
    my ( $refprefix, $suffix ) = @_;
    printf "%-35s%s\n", ${$refprefix}, $suffix;
    ${$refprefix} = "";
}


