# implementatie bind_object functie: zie sectie 5

use Win32::OLE 'in';
use Win32::OLE::Variant;
$Win32::OLE::Warn = 1;

#@ARGV=("user");  #een klasse
#@ARGV=("Ldap-Display-Name"); #een ldap-attribuut

@ARGV == 1 or die "Geef de RDN van een klasse of attribuut op als argument !\n";

my $argument=$ARGV[0];


my %E_ADS = (
    BAD_PATHNAME            => Win32::OLE::HRESULT(0x80005000),
    UNKNOWN_OBJECT          => Win32::OLE::HRESULT(0x80005004),
    PROPERTY_NOT_SET        => Win32::OLE::HRESULT(0x80005005),
    PROPERTY_INVALID        => Win32::OLE::HRESULT(0x80005007),
    BAD_PARAMETER           => Win32::OLE::HRESULT(0x80005008),
    OBJECT_UNBOUND          => Win32::OLE::HRESULT(0x80005009),
    PROPERTY_MODIFIED       => Win32::OLE::HRESULT(0x8000500B),
    OBJECT_EXISTS           => Win32::OLE::HRESULT(0x8000500E),
    SCHEMA_VIOLATION        => Win32::OLE::HRESULT(0x8000500F),
    COLUMN_NOT_SET          => Win32::OLE::HRESULT(0x80005010),
    ERRORSOCCURRED          => Win32::OLE::HRESULT(0x00005011),
    NOMORE_ROWS             => Win32::OLE::HRESULT(0x00005012),
    NOMORE_COLUMNS          => Win32::OLE::HRESULT(0x00005013),
    INVALID_FILTER          => Win32::OLE::HRESULT(0x80005014),
    INVALID_DOMAIN_OBJECT   => Win32::OLE::HRESULT(0x80005001),
    INVALID_USER_OBJECT     => Win32::OLE::HRESULT(0x80005002),
    INVALID_COMPUTER_OBJECT => Win32::OLE::HRESULT(0x80005003),
    PROPERTY_NOT_SUPPORTED  => Win32::OLE::HRESULT(0x80005006),
    PROPERTY_NOT_MODIFIED   => Win32::OLE::HRESULT(0x8000500A),
    CANT_CONVERT_DATATYPE   => Win32::OLE::HRESULT(0x8000500C),
    PROPERTY_NOT_FOUND      => Win32::OLE::HRESULT(0x8000500D) );

my $rootDSE = bind_object("rootDSE");
my $object  = bind_object( "cn=" . $argument . "," . $rootDSE->Get("schemaNamingContext") );

if ( $object->{"Class"} eq "attributeSchema" ) {
    @attributen = qw (cn distinguishedName canonicalName ldapDisplayName
        attributeID attributeSyntax rangeLower rangeUpper
        isSingleValued isMemberOfPartialAttributeSet
        searchFlags  systemFlags);
    }
elsif ( $object->{"Class"} eq "classSchema" ) {
    @attributen = qw(cn distinguishedName canonicalName ldapDisplayName
        governsID subClassOf systemAuxiliaryClass AuxiliaryClass
        objectClassCategory systemPossSuperiors possSuperiors
        systemMustContain mustContain systemMayContain mayContain);
    }
else { die("cn=$argument niet gevonden in  reeel schema\n"); }

$object->GetInfoEx([@attributen] , 0 );

foreach my $attribuut (@attributen) {
    my $prefix = $attribuut;
    my $tabel  = $object->GetEx($attribuut);

    if(Win32::OLE->LastError() == $E_ADS{PROPERTY_NOT_FOUND}){
        printlijn( \$prefix, " < niet ingesteld > ");
    }
    else{
        printlijn( \$prefix, $_ ) foreach @{$tabel};
    }
}

sub printlijn {
    my ( $refprefix, $suffix ) = @_;
    printf "%-35s%s\n", ${$refprefix}, $suffix;
    ${$refprefix} = "";
}


