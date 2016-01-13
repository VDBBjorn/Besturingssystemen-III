# implementatie bind_object functie: zie sectie 5

my $rootDSE = bind_object("rootDSE");
my $schema  = bind_object( $rootDSE->Get("schemaNamingContext") );

my $multivalued   = 0;
my $catalog       = 0;
my $geindexeerd   = 0;
my $gerepliceerd  = 0;
my $geconstrueerd = 0;
my $limited       = 0;
my $microsoft     = 0;
my $systemonly    = 0;

$schema->{Filter} = ["attributeSchema"];

foreach my $attribuut ( in $schema ){
    $multivalued++    unless $attribuut->{isSingleValued};
    $catalog++        if $attribuut->{isMemberOfPartialAttributeSet};
    $geindexeerd++    if $attribuut->{searchflags} & 1;
    $gerepliceerd++   if $attribuut->{systemFlags} & 1;
    $geconstrueerd++  if $attribuut->{systemFlags} & 4;
    $limited++        if ( defined( $attribuut->{rangeLower} )
                        || defined( $attribuut->{rangeUpper} ) );
    $microsoft++      if substr( $attribuut->{attributeID}, 0, 15 ) eq "1.2.840.113556.";
    $systemonly++     if $attribuut->{systemOnly};
}

print "\nZijn multivalued                      : " , $multivalued;
print "\nWorden opgenomen in de Global Catalog : " , $catalog;
print "\nWorden geindexeerd                    : " , $geindexeerd;
print "\nWorden niet gerepliceerd              : " , $gerepliceerd;
print "\nWorden geconstrueerd                  : " , $geconstrueerd;
print "\nHebben waarden met beperking op bereik: " , $limited;
print "\nActive Directory specifiek            : " , $microsoft;
print "\nKunnen niet gewijzigd worden          : " , $systemonly;


