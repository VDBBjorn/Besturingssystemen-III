# implementatie bind_object functie: zie sectie 5

my $ADsPath = "CN=Administrator,CN=Users,DC=iii,DC=hogent,DC=be";
my $obj = bind_object($ADsPath);
print "Binding via ADsPath = $ADsPath\n";
printf "%-19s : %s\n", $_ , $obj->{$_}
	foreach qw(Name Class GUID ADSPath Parent Schema distinguishedName);

$ADsPath = "<GUID=$obj->{GUID}>";
$obj = bind_object($ADsPath);
print "\n";
print "Binding via GUID    = $ADsPath\n";
printf "%-19s : %s\n", $_ , $obj->{$_}
	foreach qw(Name Class GUID ADSPath Parent Schema distinguishedName);


