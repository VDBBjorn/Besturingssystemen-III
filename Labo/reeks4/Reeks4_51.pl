use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName  = ".";
my $NameSpace = "root/cimv2";
my $WbemServices = Win32::OLE->GetObject("winmgmts://$ComputerName/$NameSpace");

my $Instance = $WbemServices->Get(__EventFilter)->SpawnInstance_();
$Instance->{Name}            = 'test';
$Instance->{QueryLanguage}   = 'WQL';
#Kan ook zonder interne polling, met een Excentric Event (zie onderaan)
$Instance->{Query} = qq[SELECT * FROM __InstanceCreationEvent WITHIN 1 
             WHERE TargetInstance ISA 'Win32_LogicalDisk' 
                   and TargetInstance.Name<>'B:' and TargetInstance.Name<>'A:' ];

$Filter = $Instance->Put_(wbemFlagUseAmendedQualifiers);
$Filterpad = $Filter->{path};

my $Instance = $WbemServices->Get(SMTPEventConsumer)->SpawnInstance_();
$Instance->{Name}       = "test";
$Instance->{FromLine}   = q[...@ugent.be];
$Instance->{ToLine}     = q[...@ugent.be];
$Instance->{Subject}    = "USB (%TargetInstance.Name%) inserted"; #Name-attribuut van Win32_LogicalDisk
$Instance->{SMTPServer} = "smtp.hogent.be"; #thuis anders instellen
$Consumer=$Instance->Put_(wbemFlagUseAmendedQualifiers);
$Consumerpad=$Consumer->{path};

my $Instance = $WbemServices->Get(__FilterToConsumerBinding)->SpawnInstance_();
$Instance->{Filter}   = $Filterpad;
$Instance->{Consumer} = $Consumerpad;
$Result = $Instance->Put_(wbemFlagUseAmendedQualifiers);
print $Result->{path},"\n"; #ter controle

#Tweede oplossing met Excentric Event - wijzig de oplossing op twee plaatsen:
$Instance->{Query} = qq[ SELECT * FROM Win32_VolumeChangeEvent
     WHERE EventType = 2 and DriveName <> 'B:' ];

$Instance->{Subject}    = "USB (%DriveName%) inserted op %__SERVER% - %__CLASS%"; #DriveName-attribuut van Win32_VolumeChangeEvent , enkel __CLASS in ingevuld


