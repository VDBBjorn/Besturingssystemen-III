# implementatie bind_object functie: zie sectie 5


use Win32::OLE::Const "Active DS Type Library"; #inladen type Library

my $rootDSE = bind_object("rootDSE");
my $schema  = bind_object( $rootDSE->Get("schemaNamingContext") );
my @geconstrueerd = ();
my @systemonly = ();

$schema->{Filter} = ["attributeSchema"];

foreach my $attribuut ( in $schema ) {
    push @geconstrueerd, $attribuut->{ldapDisplayName} if $attribuut->{systemFlags} & ADS_SYSTEMFLAG_ATTR_IS_CONSTRUCTED;
    push @systemonly,    $attribuut->{ldapDisplayName} if $attribuut->{systemOnly};
    }

print "\nWorden geconstrueerd         : \n" , join ("\n\t", @geconstrueerd );
print "\nKunnen niet gewijzigd worden : \n" , join ("\n\t", @systemonly    );


