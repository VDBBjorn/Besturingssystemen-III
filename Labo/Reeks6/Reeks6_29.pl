# implementatie bind_object functie: zie sectie 5

use Win32::OLE 'in';
use Win32::OLE::Variant;
use Win32::OLE::Const "Active DS Type Library";
$Win32::OLE::Warn = 3;

#serverless binding
my $RootObj = bind_object("RootDSE");

my $administrator = bind_object("CN=Administrator,CN=Users,".$RootObj->get(defaultNamingContext));

$administrator->GetInfo();

print "Aantal attributen in de Property Cache: $administrator->{PropertyCount}\n";

for ( my $i = 0 ; $i < $administrator->{PropertyCount}; $i++ ){

    my $attribuut = $administrator->Next();
#   my $attribuut = $administrator->Item($i); #alternatief
    my $prefix    = $attribuut->{Name} . " (" . $attribuut->{ADsType} . ")";
    foreach my $propValue ( @{$attribuut->{Values}} )  {
        if ( $attribuut->{ADsType} == ADSTYPE_NT_SECURITY_DESCRIPTOR) {
             $sec_object=$propValue->GetObjectProperty($attribuut->{ADsType});
             $suffix = "eigenaar is ..." . $sec_object->{owner};
        }
        elsif ( $attribuut->{ADsType} == ADSTYPE_OCTET_STRING) {
            $inhoud=$propValue->GetObjectProperty($attribuut->{ADsType});
            $suffix = sprintf "%*v02X ","",$inhoud;
        }
        elsif ( $attribuut->{ADsType} == ADSTYPE_LARGE_INTEGER ) {
            $inhoud=$propValue->GetObjectProperty($attribuut->{ADsType});
            $suffix = convert_BigInt_string($inhoud->{HighPart},$inhoud->{LowPart});
        }
        else  {
            $suffix = $propValue->GetObjectProperty($attribuut->{ADsType});
            }
        printlijn( \$prefix, $suffix );
   }
}

#een groot geheel getal wordt teruggegeven als twee gehele getallen
#vb  29868835, -1066931206
# Het groot geheel getal dat hierbij hoort moet je berekenen als volgt :
# 29868835 . 2^32 + (2^32 - 1066931206 ) = 128285672722656250
# Onderstaande functie berekent deze waarde met behulp van de module Math::BigInt.
# Een bijkomend probleem is dat je deze waarde enkel met print juist uitschrijft,
# gebruik je printf dan moet je %s en niet %g gebruiken, anders krijg je een "afgeronde" waarde.
use Math::BigInt;
sub convert_BigInt_string{
    my ($high,$low)=@_;
    my $HighPart = Math::BigInt->new($high);
    my $LowPart = Math::BigInt->new($low);
    my $Radix = Math::BigInt->new('0x100000000'); #dit is 2^32
    $LowPart+=$Radix if ($LowPart<0); #als unsigned int interperteren

    return ($HighPart * $Radix + $LowPart);
}

sub printlijn {
    my ( $refprefix, $suffix ) = @_;
    printf "%-35s%s\n", ${$refprefix}, $suffix;
    ${$refprefix} = "";
}


