use Win32::OLE 'in';

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

# constructie %AntecendentHash en %DependentHash hashes voor performantere oplossing
my $ClassName = "Win32_DependentService";
my $Instances = $WbemServices->InstancesOf($ClassName);
foreach my $Instance (in $Instances) {
    #behoud enkel de name van de services voor deze afhankelijkheid
    my ($Antecedent,$Dependent) = ($Instance->{Antecedent}=~ /="(.*)"/, $Instance->{Dependent}=~ /="(.*)"/);

    push @{$AntecedentHash{$Dependent}},$Antecedent;
    push @{$DependentHash{$Antecedent}},$Dependent;
}

my $ClassName = "Win32_Service";

my $Instances = $WbemServices->ExecQuery("Select * From $ClassName Where State = 'Running'");

#hardgecodeerde lijst - vraag eventueel eerst een overzicht van alle mogelijke attributen met oefening 13
@toonprop=qw (DisplayName Name );#Description Status StartMode StartName);

foreach my $Instance (in $Instances) {
    print "\n--------------------------------------------------------------\n";
    foreach my $prop (@toonprop){
        printf "\t%-15s : %s\n ",$prop, $Instance->{$prop};
    }

# meer performante oplossing, vereist voorafgaande constructie %AntecendentHash en %DependentHash
    @Antecedent=@{$AntecedentHash{$Instance->{Name}}};
    @Dependent =@{$DependentHash{ $Instance->{Name}}};

# minder performante oplossing
   #$query="Associators of {Win32_Service.Name='$Instance->{Name}'}
   #              Where AssocClass=Win32_DependentService Role=Dependent";
   #@Antecedent=map {$_->{Name}} in $WbemServices->ExecQuery($query);

   #$query="Associators of {Win32_Service.Name='$Instance->{Name}'}
   #              Where AssocClass=Win32_DependentService Role=Antecedent";
   #@Dependent =map {$_->{Name}} in $WbemServices->ExecQuery($query);

    print "\t   Antecedent Services : " , (join ",",@Antecedent) , "\n";
    print "\t   Dependent  Services : " ,  (join ",",@Dependent) , "\n";
}



