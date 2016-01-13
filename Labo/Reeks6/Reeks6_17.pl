# implementatie bind_object functie: zie sectie 5

my $class=$ARGV[0];
my $Users = bind_object("CN=Users,DC=iii,DC=hogent,DC=be");
$Users->{Filter} = [$class];
print "AD-objecten van type $class:\n";
print "$_->{adspath}\n" foreach in $Users;

print "\nAdministrator:\n";
my $a = $Users->GetObject("user","CN=Administrator");
print $a->{ADsPath};


