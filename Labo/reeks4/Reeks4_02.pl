use Win32::OLE;
my $NameSpace = "root/cimv2";
$Win32::OLE::Warn = 3; #script stopt met foutmelding als er ergens iets niet lukt

# connectie aan lokaal toestel
my $ComputerName = ".";
# of 
#my $ComputerName = "localhost";

my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);
print join(" / ",Win32::OLE->QueryObjectType($WbemServices)) , "\n";
#OF direct initialiseren
my $WbemServices = Win32::OLE->GetObject("winmgmts://$ComputerName/$NameSpace");
print join(" / ",Win32::OLE->QueryObjectType($WbemServices)) , "\n";

#alternatieven voor een foutmelding zonder instellen van Warn
print "connection gelukt\n " if ref($WbemServices);
Win32::OLE->LastError() ==0 || die "niet gelukt\n";

# connectie aan ander toestel
my $ComputerName = "mozart";              # naam willekeurig in windows opgestart toestel
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace,"$ComputerName\\administrator","...."); #vul in
print join(" / ",Win32::OLE->QueryObjectType($WbemServices)) , "\n";



