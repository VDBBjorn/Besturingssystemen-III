# implementatie bind_object functie: zie sectie 5

my $RootObj = bind_object("RootDSE");
$RootObj->{DnsHostName}; #om de PropertyCache te initialiseren - zie later

print "Domeingegevens:        $RootObj->{defaultNamingContext}\n";
print "Configuratie gegevens: $RootObj->{configurationNamingContext}\n";
print "Schema:                $RootObj->{schemaNamingContext}\n";

#alternatief, haalt alle partities op:
print join("\n",@{$RootObj->{"namingContexts"}});

#in powerShell:
$monikerRoot = "LDAP://RootDSE"  #thuis de moniker aanpassen
$rootObject =[adsi] $monikerRoot #indien ingelogd op het domein
$rootObject.namingContexts


