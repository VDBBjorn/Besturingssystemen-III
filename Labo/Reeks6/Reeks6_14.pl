# implementatie bind_object functie: zie sectie 5

sub GetDomeinDN {
    my $RootObj = bind_object("RootDSE");
    $RootObj->{DnsHostName}; #om de PropertyCache te initialiseren - zie later
    return $RootObj->{defaultNamingContext};      
}

my $UsersContainerGUID             = "a9d1ca15768811d1aded00c04fd8d5cd";
my $ComputersContainerGUID         = "aa312825768811d1aded00c04fd8d5cd";
my $SystemsContainerGUID           = "ab1d30f3768811d1aded00c04fd8d5cd";
my $DomainControllersContainerGUID = "a361b2ffffd211d1aa4b00c04fd7d83a";
my $InfrstructureContainerGUID     = "2fbac1870ade11d297c400c04fd8d5cd";
my $DeletedObjectContainerGUID     = "18e2ea80684f11d2b9aa00c04f79f805";
my $LostAndFoundContainerGUID      = "ab8153b7768811d1aded00c04fd8d5cd";

my $DomeinDN = GetDomeinDN();

my $ADsPath = "<WKGUID=$UsersContainerGUID,$DomeinDN>";
my $obj  = bind_object($ADsPath);
print "\n";
print "Binding via WKGUID:    $ADsPath\n";
print "RDN:                   $obj->{Name}\n";
print "klasse:                $obj->{Class}\n";
print "objectGUID:            $obj->{GUID}\n";
print "ADsPath:               $obj->{ADsPath}\n";
print "ADsPath Parent:        $obj->{Parent}\n";
print "ADsPath schema klasse: $obj->{Schema}\n";
print "\n";

$ADsPath = $obj->{distinguishedName};
$obj = bind_object($ADsPath);
print "Binding via DN:        $ADsPath\n";
print "RDN:                   $obj->{Name}\n";
print "klasse:                $obj->{Class}\n";
print "objectGUID:            $obj->{GUID}\n";
print "ADsPath:               $obj->{ADsPath}\n";
print "ADsPath Parent:        $obj->{Parent}\n";
print "ADsPath schema klasse: $obj->{Schema}\n";

