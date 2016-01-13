use Win32::OLE 'in';
$Win32::OLE::Warn = 3; #script stopt met foutmelding als er ergens iets niet lukt

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $ClassName = "Win32_NetworkAdapter";

my $moniker="winmgmts://$ComputerName/$NameSpace:$ClassName";
my $Klasse = Win32::OLE->GetObject($moniker);
# alternatieve foutafhandeling
print "connection gelukt\n " if ref($Klasse);
Win32::OLE->LastError() ==0 || die "niet gelukt\n";
print "\nObjecttype van de klasse: ", join(" / ",Win32::OLE->QueryObjectType($Klasse)),"\n" ;

#OF
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);
my $Klasse = $WbemServices->Get($ClassName);
print "\nObjecttype van de klasse: ",join(" / ",Win32::OLE->QueryObjectType($Klasse)),"\n" ;

#Instantie

$DeviceID="9";           #de waarde van het sleutelattribuut opzoeken in WMI&nbsp;CIM&nbsp;Studio en gepast invullen
my $moniker="winmgmts://$ComputerName/$NameSpace:$ClassName.DeviceID=\"$DeviceID\"";
#of
#my $moniker="winmgmts://$ComputerName/$NameSpace:$ClassName.DeviceID='$DeviceID'";
#Zoek de juiste moniker op in WMI&nbsp;CIM&nbsp;Studio

my $Instance = Win32::OLE->GetObject($moniker);
print "\nObjecttype van de instantie =", join(" / ",Win32::OLE->QueryObjectType($Instance));
print "\nName= ",$Instance->{Name};

#OF
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);
my $Instance = $WbemServices->Get("$ClassName.DeviceID=\"$DeviceID\"");
#mogelijk alternatief met ''-tekens
#my $Instance = $WbemServices->Get("$ClassName.DeviceID='$DeviceID'");
print "\nObjecttype van de instantie=", join(" / ",Win32::OLE->QueryObjectType($Instance));
print "\nName= ",$Instance->{Name};




