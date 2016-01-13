use Win32::OLE;
my $NameSpace = "root/cimv2";
$Win32::OLE::Warn = 3; #script stopt met foutmelding als er ergens iets niet lukt

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

#my $Instances = $WbemServices->InstancesOf("Win32_OperatingSystem");
#OF via het WMI object dat de klasse bevat
my $class = $WbemServices->get("Win32_OperatingSystem");
my $Instances = $class->Instances_();
#OF met WQL-query
#my $Instances = $WbemServices->ExecQuery("SELECT * FROM Win32_OperatingSystem");

my ($Instance) = in $Instances; #unieke instantie ophalen
print $Instance->{Caption},"versie ",$Instance->{Version},"\n",$Instance->{CSDVersion},"\n",$Instance->{OSArchitecture};


