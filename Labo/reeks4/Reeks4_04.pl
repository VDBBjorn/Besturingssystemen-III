use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);
#Gebruik ' ' in de relatieve padnaam
my $Instance = $WbemServices->Get("Win32_Directory.Name='c:\\'");
#Gebruik \\ tussen ""-tekens
my $Instance = $WbemServices->Get("Win32_Directory.Name=\"c:\\\\\"");
print "FileType = ",$Instance->{FSName};


