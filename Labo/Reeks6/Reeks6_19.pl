# implementatie bind_object functie: zie sectie 5

$RootObj = bind_object("RootDSE");
$RootObj->{dnsHostName}; #initialiseren van Property Cache

@containers=qw(defaultNamingContext configurationNamingContext schemaNamingContext);

@ARGV = 0..2 unless @ARGV;
foreach $nr (@ARGV) {
    bepaal_klassen($RootObj->{$containers[$nr]});
}

#OF
#@containers=@{$RootObj->{"namingContexts"}}; #bevat 5 elementen
#@ARGV = 0..4 unless @ARGV; #er zijn 5 elementen
#foreach $nr (@ARGV) {
#    bepaal_klassen($containers[$nr]);
#}


my %classes;

sub bepaal_klassen {
    $contname=shift;
    print "\n zoek in : ",$contname;
    print "\nEven geduld !!! \n";
    $obj=bind_object($contname);
    $classes{$obj->{class}}=1;
    zoek($obj);
    $n = scalar(keys %classes);
    print "\n$n verschillende klassen in $contname\n";
    print_geordend();
    %classes=();   #hash opkuisen
}

sub zoek {
    my $cont=shift;
    foreach my $obj (in $cont) {
        $classes{$obj->{class}}++;
        print "\n",$obj->{class} if $classes{$obj->{class}}%100==99;
        zoek ($obj);    #recursief
    }
}

sub print_geordend {
    printf "\n%-20s : %s",$_,$classes{$_}
        foreach sort { $classes{$b}<=> $classes{$a} } keys %classes;
}




