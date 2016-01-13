# implementatie bind_object functie: zie sectie 5

use Win32::OLE 'in';
use Win32::OLE::Variant;
$Win32::OLE::Warn = 1;

my $rootDSE = bind_object("rootDSE");
my $schema  = bind_object( $rootDSE->Get("schemaNamingContext") );
my %attributeSyntax = ();
my %omSyntax = ();

$schema->{Filter} = ["attributeSchema"];

foreach my $attr_reeel ( in $schema ) {
    my $attr_abstract = bind_object( "schema/" . $attr_reeel->{ldapDisplayName} );
    $attributeSyntax{ $attr_abstract->{Syntax} } = $attr_reeel->{attributeSyntax};
    $omSyntax{ $attr_abstract->{Syntax} }        = $attr_reeel->{omSyntax};
}

print "syntax van abstract object \t    syntax van reeel object\n";
print "                           \tattributeSyntax \tomSyntax\n";
print "-------------------------- \t---------------------------------\n";
foreach my $i ( sort { substr( $attributeSyntax{$a}, 6 ) <=> substr( $attributeSyntax{$b}, 6 )
                          || $omSyntax{$a} <=> $omSyntax{$b}
		   } keys %attributeSyntax ){

    printf "%-24s\t%-18s\t%d\n", $i, $attributeSyntax{$i}, $omSyntax{$i};
}

