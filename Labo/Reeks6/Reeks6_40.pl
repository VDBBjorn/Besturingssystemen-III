# implementatie bind_object functie: zie sectie 5

use Win32::OLE 'in';
use Win32::OLE::Variant;
$Win32::OLE::Warn = 1;

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

my $teller = 0;
#serverless binding
my $RootObj = bind_object("RootDSE");

my $object = bind_object("CN=Administrator,CN=Users,".$RootObj->get(defaultNamingContext));
my $abstracteKlasse = bind_object($object->{Schema});

$object->GetInfoEx( $abstracteKlasse->{MandatoryProperties}, 0 );    # De Property Cache wordt ingevuld
$object->GetInfoEx( $abstracteKlasse->{OptionalProperties} , 0 );

foreach my $LDAPattribuut ( in $abstracteKlasse->{MandatoryProperties}, $abstracteKlasse->{OptionalProperties} ) 
 {
    $teller++;
    my $abstractLdapAttribuut = bind_object( "schema/$LDAPattribuut" );
    my $prefix =  "$teller: $LDAPattribuut  ($abstractLdapAttribuut->{Syntax})";
    my $tabel = $object->GetEx($LDAPattribuut);

    if ( Win32::OLE->LastError() == $E_ADS{PROPERTY_NOT_FOUND} )  {
    	printlijn( \$prefix, "<niet ingesteld>" );
    }
    else {
        foreach my $value ( @{$tabel} ) {
            if ( $abstractLdapAttribuut->{Syntax} eq "OctetString" ) {
                $waarde=sprintf ("%*v02X ","", $value) ;
            }
            elsif ( $abstractLdapAttribuut->{Syntax} eq "ObjectSecurityDescriptor" ) {
                $waarde="eigenaar is ... $value->{owner}";
            }
            elsif ( $abstractLdapAttribuut->{Syntax} eq "INTEGER8" ){
                $waarde=convert_BigInt_string($value->{HighPart},$value->{LowPart});
            }
            else {
                $waarde=$value;
            }
            printlijn( \$prefix, $waarde );
	}
    }
}

sub printlijn {
    my ( $refprefix, $suffix ) = @_;
    printf "%-55s%s\n", ${$refprefix}, $suffix;
    ${$refprefix} = "";
}

use Math::BigInt;
sub convert_BigInt_string{
    my ($high,$low)=@_;
    my $HighPart = Math::BigInt->new($high);
    my $LowPart  = Math::BigInt->new($low);
    my $Radix    = Math::BigInt->new('0x100000000'); #dit is 2^32
    $LowPart+=$Radix if ($LowPart<0); #als unsigned int interperteren

    return ($HighPart * $Radix + $LowPart);
}


