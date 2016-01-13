use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';
$Win32::OLE::Warn = 3; #script stopt met foutmelding als er ergens iets niet lukt

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);


my $Instance = $WbemServices->Get("__IntervalTimerInstruction")->SpawnInstance_();
$Instance->{TimerID}  = 'test';
$Instance->{IntervalBetweenEvents} = 60000;
$instancePath=$Instance->Put_(wbemFlagUseAmendedQualifiers);

#Oorzaak event koppelen aan voorgaand object : 
my $InstanceEvent = $WbemServices->Get("__EventFilter")->SpawnInstance_();
$InstanceEvent->{Name}="test";
$InstanceEvent->{QueryLanguage}="WQL";
$InstanceEvent->{Query}="SELECT * FROM __TimerEvent where TimerID = 'test'";
$Filter = $InstanceEvent->Put_(wbemFlagUseAmendedQualifiers);
$Filterpad=$Filter->{path};

#Reacties :
my $InstanceReactie = $WbemServices->Get(CommandLineEventConsumer)->SpawnInstance_();
$InstanceReactie->{Name}="test";
$InstanceReactie->{CommandLineTemplate}="C:\\WINDOWS\\system32\\net.exe start snmp";
$Consumer = $InstanceReactie->Put_(wbemFlagUseAmendedQualifiers);
$Consumerpad=$Consumer->{path}; 

# Koppeling : 
my $InstanceKoppeling = $WbemServices->Get(__FilterToConsumerBinding)->SpawnInstance_();
$InstanceKoppeling->{Filter}   = $Filterpad;
$InstanceKoppeling->{Consumer} = $Consumerpad;
$Result=$InstanceKoppeling->Put_(wbemFlagUseAmendedQualifiers);
print $Result->{Path},"\n"; #ter controle


