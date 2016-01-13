use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);
my $Instance = $WbemServices->Get("Win32_Directory.Name='c:\\'");
#of
#my $Instances = $WbemServices->execQuery("select * from Win32_Directory where Name='c:\\'");
#my ($Instance)=(in $Instances);

my $Associators = $Instance->Associators_(); #alle instanties, geassocieerd met deze instantie
print $Associators->{Count} , " exempla(a)r(en) \n";

my $Associators = $Instance->Associators_(undef,undef,undef,undef,1); #enkel de klassen voor de geassocieerde objecten
print $Associators->{Count} , " exempla(a)r(en) \n";



