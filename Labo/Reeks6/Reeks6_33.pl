my $rootDSE = bind_object("rootDSE");
my $schema  = bind_object( $rootDSE->Get("schemaNamingContext") );

my $topkind         = 0;
my $auxiliary       = 0;
my $hulpafhankelijk = 0;
my $microsoft       = 0;
my $systemonly      = 0;
my $RDNnotCN        = 0;

$schema->{Filter} = ["classSchema"]; #enkel klassen

foreach my $klasse ( in $schema ) {
    $topkind++         if $klasse->{subClassOf} eq "top";
    $auxiliary++       if $klasse->{objectClassCategory} == 3;
    $hulpafhankelijk++ if ( defined( $klasse->{systemAuxiliaryClass} )
                         || defined( $klasse->{AuxiliaryClass} ) );
    $microsoft++       if substr( $klasse->{governsID}, 0, 15 ) eq "1.2.840.113556."; #vind je ook terug in de AD Library bij governsId
    $systemonly++      if $klasse->{systemOnly};
    $RDNnotCN++        if $klasse->{rdnAttID} ne "cn";
}

print "\nKinderen van top             : " , $topkind;
print "\nHulpklassen                  : " , $auxiliary;
print "\nAfhankelijk van hulpklasse(n): " , $hulpafhankelijk;
print "\nActive Directory specifiek   : " , $microsoft;
print "\nKunnen niet gewijzigd worden : " , $systemonly;
print "\nRDN niet van de vorm CN=...  : " , $RDNnotCN;


