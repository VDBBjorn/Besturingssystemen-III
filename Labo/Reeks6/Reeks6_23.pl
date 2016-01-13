# implementatie bind_object functie: zie sectie 5b

#eerste mogelijkheid:
my $RootObj = bind_object("RootDSE");
$RootObj->getInfo();

print "Domeingegevens:        $RootObj->{defaultNamingContext}\n";
print "Configuratie gegevens: $RootObj->{configurationNamingContext}\n";
print "Schema:                $RootObj->{schemaNamingContext}\n";

#OF Tweede mogelijkheid
my $RootObj = bind_object("RootDSE");
print "Domeingegevens:        ",$RootObj->get(defaultNamingContext),"\n";
print "Configuratie gegevens: ",$RootObj->get(configurationNamingContext),"\n";
print "Schema:                ",$RootObj->get(schemaNamingContext),"\n";

#Alternatief om de 5 partities op te halen:
#eerste mogelijkheid:
my $RootObj = bind_object("RootDSE");
$RootObj->getInfo();
print join("\n",@{$RootObj->{"namingContexts"}});

#OF Tweede mogelijkheid
my $RootObj = bind_object("RootDSE");
print join("\n",@{$RootObj->get("namingContexts")});


