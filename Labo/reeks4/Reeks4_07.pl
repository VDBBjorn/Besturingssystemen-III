$Win32::OLE::Warn = 3;
use Win32::OLE 'in';

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $ClassName = "Win32_NetworkAdapter";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");

my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

# via InstancesOf <i>SWbemServices</i>
my $Instances = $WbemServices->InstancesOf($ClassName);
print "->InstancesOf  heeft objecttype : ", join(" / ",Win32::OLE->QueryObjectType($Instances)) , "\n\n";
print $Instances->{Count} , " netwerkadapters met sleutelattribuut DeviceID :\n";
print "\tEen WMI object met DeviceID=",$_->{DeviceID},"\n"
     foreach in $Instances;

#Mogelijk alternatief voor alle instanties met query ;

my $Instances = $WbemServices->ExecQuery("Select * From $ClassName");

#Alternatief voor het ophalen van de waarden van het attribute <i>DeviceID</i> :

@DeviceId=map{$_->{DeviceID}} in $Instances;

print "\n",scalar (@DeviceId), " netwerkadapters met sleutelattribuut: \n\t DeviceID=";
print join("\n\t DeviceId=",@DeviceId);



