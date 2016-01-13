use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName  = ".";
my $NameSpace = "root/cimv2";
my $WbemServices = Win32::OLE->GetObject("winmgmts://$ComputerName/$NameSpace");

my $Instance = $WbemServices->Get(__EventFilter)->SpawnInstance_();
$Instance->{Name}           = 'test';
$Instance->{QueryLanguage}  = 'WQL';

#Met Excentric event
$Instance->{Query} = qq[SELECT * FROM Win32_VolumeChangeEvent  WHERE EventType = 2 and DriveName <> 'B:' ];
#Met interne polling
$Instance->{Query} = qq[SELECT * FROM __InstanceCreationEvent WITHIN 1  
                           WHERE TargetInstance ISA 'Win32_LogicalDisk' 
                           and TargetInstance.Name<>'B:' 
                           and TargetInstance.Name<>'A:' ];

$Filter   = $Instance->Put_(wbemFlagUseAmendedQualifiers);
$Filterpad = $Filter->{path};

my $Instance = $WbemServices->Get(ActiveScriptEventConsumer)->SpawnInstance_();
$Instance->{Name}             = "test";
$Instance->{ScriptingEngine}  = "PerlScript";
$Instance->{ScriptText}       = q[open FILE, ">>C:\\\\usb.txt";print FILE "USB ingeplugd\n"; ];  #(*)
$Consumer  = $Instance->Put_(wbemFlagUseAmendedQualifiers);
$Consumerpad = $Consumer->{path};


my $Instance = $WbemServices->Get(__FilterToConsumerBinding)->SpawnInstance_();
$Instance->{Filter}   = $Filterpad;
$Instance->{Consumer} = $Consumerpad;
$Result = $Instance->Put_(wbemFlagUseAmendedQualifiers);
print Win32::OLE->LastError(),"\n";
print $Result->{path};

#(*) indien je FSO gebruikt wordt de scripttext:
$Instance->{ScriptText} =  qq[
		use Win32::OLE::Const;
		my $fso = Win32::OLE->new("Scripting.FileSystemObject");
		my $const = Win32::OLE::Const->Load($fso);
		
		my $forAppending = $const->{ForAppending}; #ophalen van deze constante
		
		my $naam='c:\\temp\usb.txt'; 
		if (!$fso->FileExists($naam))
		{
		    $fso->CreateTextFile($naam);
		}
		
		my $tekstFile = $fso->OpenTextFile($naam, $forAppending);
		$tekstFile->writeLine( "USB ingeplugd\n");
		$tekstFile->close();
 ]; 




