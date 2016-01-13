use Win32::OLE 'in';
#onderstaande variabele opzoeken in WMI CIM Studio en gepast invullen
my $IRQNumber=18;           #het sleutelattribuut van de associatorklasse


my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $ClassName = "Win32_NetworkAdapter";   #enkel netwerkverbindingen
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

#eerste methode
print "\n\nvia AssociatorsOf van SWbemServices (duurt even)\n";
#hier moet je zelf het relpad opbouwen
my $relpad="Win32_IRQResource.IRQNumber=$IRQNumber";
my $Instances = $WbemServices->AssociatorsOf($relpad , undef,$ClassName);
print $Instances->{Count} , " exempla(a)r(en)";  #indien dit aantal nul is moet je vertrekken van een ander IRQNumber
print "\n\tNetConnectionId=",$_->{"NetConnectionId"} foreach in $Instances;

#tweede methode 
print "\n\nvia Associators_ van een SWbemObject (duurt even)\n";
#zoek het juiste object, uitgevoerd met een WQL-query
my $WbemObjectSet = $WbemServices->ExecQuery("Select * from Win32_IRQResource  WHERE IRQNumber=$IRQNumber");
(my $WbemObject)=(in $WbemObjectSet);
#haal zijn associatorklassen op
my $Instances = $WbemObject->Associators_(undef,$ClassName);
print $Instances->{Count} , " exempla(a)r(en)";
print "\n\tNetConnectionId=",$_->{"NetConnectionId"} foreach in $Instances;


