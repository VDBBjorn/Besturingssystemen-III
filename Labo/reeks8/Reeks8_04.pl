#. . . implementatie functie bind_object zie sectie 5 in reeks 6
#. . . implementatie functie valueattribuut: zie oefening 1
my $RootObj=bind_object("RootDSE"); #serverless Binding
   $RootObj->getinfo();

@ARGV == 1 or die "geef als enige parameter de naam van de ou\n";
my $cont=bind_object("ou= ... ,OU=Labo,".$RootObj->{defaultNamingContext});
my %lijst;
foreach (in $cont) {
        $_->GetInfoEx(["canonicalName"],0);
        $_->Get("canonicalName") =~ m[.*/(.*)$];
        $lijst{lc($1)}=undef;
}

my $ou_naam=$ARGV[0];
while (exists $lijst{lc($ou_naam)} || !$ou_naam) {
     print qq[canonicalName moet uniek zijn !\nde volgende namen mag je niet meer nemen in deze container: "]
          ,join ('" "',keys %lijst),qq["\ngeef nieuwe naam:];
     chomp($ou_naam=<STDIN>);
}

my $ou=$cont->Create("organizationalunit", "ou=$ou_naam");  #vergeet niet ou= toe te voegen in de tweede parameter.
$ou->SetInfo();  #op het nieuwe object - niet op de container
print "toegevoegd met verplichte properties ",join (", ",in bind_object($ou->{schema})->{MandatoryProperties})
     unless (Win32::OLE->LastError());



