#Zoek een klasse met als attribuut "servicepack" en je vind de singleton klasse "Win32_OperatingSystem"
use Win32::OLE;
my $NameSpace = "root/cimv2";
$Win32::OLE::Warn = 3; #script stopt met foutmelding als er ergens iets niet lukt

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

my $Instance = $WbemServices->Get("Win32_OperatingSystem=@"); #uniek instantie van de singleton-klasse
#Informatie over de Windows-versie
print $Instance->{Caption},"versie ",$Instance->{Version},"\n",$Instance->{CSDVersion},"\n",$Instance->{OSArchitecture};


