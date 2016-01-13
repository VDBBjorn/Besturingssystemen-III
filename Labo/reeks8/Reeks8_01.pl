#. . .  implementatie bind_object functie: zie reeks 6, oefening 4
# er werd voor gezorgd dat er steeds een array-referentie terugkrijgt. Je kan dus volgende code gebruiken om de return-waarde te tonen:

foreach ( @{valueattribuut($object,$attribuut)} ) {
         print "\t$_\n";
}

sub valueattribuut {
    my ($object,$attribuut)=@_;
    my $attr_schema = bind_object( "schema/$attribuut" );
    my $tabel = $object->GetEx($attribuut);

    if (Win32::OLE->LastError() == Win32::OLE::HRESULT(0x8000500D)){
	$object->GetInfoEx([$attribuut], 0);
        $tabel = $object->GetEx($attribuut);
    }
    return ["<niet ingesteld>"] if Win32::OLE->LastError() == Win32::OLE::HRESULT(0x8000500D);

    my $v=[];
    foreach ( in $tabel ) {
        if ( $attr_schema->{Syntax} eq "OctetString" ) {
            $waarde = sprintf ("%*v02X ","", $_) ;
        }
        elsif ( $attr_schema->{Syntax} eq "ObjectSecurityDescriptor" ) {
            $waarde = "eigenaar is ... " . $_->{owner};
        }
        elsif ( $attr_schema->{Syntax} eq "INTEGER8" ) {
            $waarde = convert_BigInt_string($_->{HighPart},$_->{LowPart});
        }
        else {
            $waarde = $_;
        }
        push @{$v},$waarde;
    }
    return $v;
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


