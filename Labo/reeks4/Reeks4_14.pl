use Win32::OLE 'in';

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $ClassName = "Win32_Service";
#my $InstanceName = "SNMP";
my $InstanceName = "Browser";

my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

my $Instance = $WbemServices->Get("$ClassName.Name='$InstanceName'");#de juiste instantie ophalen.

#voor de bijhorende klasse zijn enkel de systeemattributen ingevuld
#my $Instance = $WbemServices->Get("$ClassName");#de bijhorende klasse.

printf "%-30s %s\n", $_->{Name}
                   , ref( $_->{Value} ) eq "ARRAY"  ? join ",",@{$_->{Value}}  : $_->{Value}
    foreach sort {uc($a->{Name}) cmp uc($b->{Name})} in $Instance->{Properties_},$Instance->{SystemProperties_};




