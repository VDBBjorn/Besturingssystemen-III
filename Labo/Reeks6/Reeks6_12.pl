# implementatie bind_object functie: zie sectie 5
tt              
sub GetDomeinDN {
    my $RootObj = bind_object("RootDSE");

    print "Server DNS:               $RootObj->{dnsHostName}\n";
    print "       SPN:               $RootObj->{ldapServiceName}\n";
    print "       Datum & tijd:      $RootObj->{currentTime}\n";
    print "       Global Catalog ?   $RootObj->{isGlobalCatalogReady}\n";
    print "       gesynchronizeerd ? $RootObj->{isSynchronized}\n";
    print "       DN:                $RootObj->{serverName}\n";

    print "Domeingegevens:           $RootObj->{defaultNamingContext}\n";
    print "Configuratiegegevens:     $RootObj->{configurationNamingContext}\n";
    print "Schema:                   $RootObj->{schemaNamingContext}\n";

    print "Functioneel niveau \n";
    print "    Forest:               $RootObj->{forestFunctionality}\n";
    print "    Domein:               $RootObj->{domainFunctionality}\n";

    return $RootObj->{defaultNamingContext};
}

my $DomeinDN = GetDomeinDN();

my $o = bind_object("CN=Administrator,CN=Users,$DomeinDN");
print "\n";
print "RDN:                   $o->{Name}\n";
print "klasse:                $o->{Class}\n";
print "objectGUID:            $o->{GUID}\n";
print "ADsPath:               $o->{ADsPath}\n";
print "ADsPath Parent:        $o->{Parent}\n";
print "ADsPath schema klasse: $o->{Schema}\n";

#PowerShell: na connecteren met de juiste moniker voor het RootDSE-object, kan je met Get-Member deze interessante eigenschappen snel terugvinden.


