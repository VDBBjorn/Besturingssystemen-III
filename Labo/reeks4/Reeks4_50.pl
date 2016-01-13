use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';
$Win32::OLE::Warn = 3; #script stopt met foutmelding als er ergens iets niet lukt

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);


#Oorzaak event opstarten van calc of notepad
my $InstanceEvent = $WbemServices->Get("__EventFilter")->SpawnInstance_();
$InstanceEvent->{Name}          = "test2";
$InstanceEvent->{QueryLanguage} = "WQL";
#Kan ook zonder interne polling, met een Excentric Event (zie onderaan)
$InstanceEvent->{Query}="SELECT * FROM __InstanceCreationEvent 
                     WITHIN 10 
                     WHERE TargetInstance ISA 'Win32_Process' 
                     AND (TargetInstance.Name = 'notepad.exe'
                     OR  TargetInstance.Name = 'calc.exe')";
$Filter = $InstanceEvent->Put_(wbemFlagUseAmendedQualifiers);
$Filterpad=$Filter->{path};

#Reactie 1 :
#creeer een "CommandLineEventConsumer" object
my $InstanceReactie1 = $WbemServices->Get(CommandLineEventConsumer)->SpawnInstance_();
$InstanceReactie1->{Name}                = "test2";
$InstanceReactie1->{CommandLineTemplate} = "C:\\WINDOWS\\system32\\taskkill.exe /f /pid %TargetInstance.ProcessId%";
$Consumer1 = $InstanceReactie1->Put_(wbemFlagUseAmendedQualifiers);
$Consumerpad1=$Consumer1->{path}; 
print $InstanceReactie1->{CommandLineTemplate},"\n";

#Reactie 2 :
#creeer een "SMTPEventConsumer" object
my $InstanceReactie2 = $WbemServices->Get(SMTPEventConsumer)->SpawnInstance_();
$InstanceReactie2->{Name}       = "test2";
$InstanceReactie2->{FromLine}   = "....\@ugent.be";
$InstanceReactie2->{ToLine}     = "....\@ugent.be";
$InstanceReactie2->{Subject}    = "%TargetInstance.Caption% started on %__SERVER%";
$InstanceReactie2->{SMTPServer} = "smtp.hogent.be"; #mail server op school
$Consumer2 = $InstanceReactie2->Put_(wbemFlagUseAmendedQualifiers);
$Consumerpad2=$Consumer2->{path}; 

#Twee koppelingen :
my $InstanceKoppeling1          = $WbemServices->Get(__FilterToConsumerBinding)->SpawnInstance_();
$InstanceKoppeling1->{Filter}   = $Filterpad;
$InstanceKoppeling1->{Consumer} = $Consumerpad1;
$Result1=$InstanceKoppeling1->Put_(wbemFlagUseAmendedQualifiers);
print $Result1->{Path},"\n"; #ter controle

my $InstanceKoppeling2 = $WbemServices->Get(__FilterToConsumerBinding)->SpawnInstance_();
$InstanceKoppeling2->{Filter}   = $Filterpad;
$InstanceKoppeling2->{Consumer} = $Consumerpad2;
$Result2=$InstanceKoppeling2->Put_(wbemFlagUseAmendedQualifiers);
print $Result2->{Path},"\n"; #ter controle


#Oplossing met Excentric Event - wijzig de oplossing op drie plaatsen:

$InstanceEvent->{Query}="SELECT * FROM Win32_ProcessTrace WHERE ProcessName = 'notepad.exe' OR  ProcessName = 'calc.exe'";

$InstanceReactie1->{CommandLineTemplate} = "C:\\WINDOWS\\system32\\taskkill.exe /f /pid %ProcessId%"; #direct ophalen zonder tussenkomst van TargetInstance
$InstanceReactie2->{Subject}    = "%ProcessName% started on %__SERVER% en %__CLASS%"; #__SERVER is niet ingevuld, __CLASS blijkbaar wel




