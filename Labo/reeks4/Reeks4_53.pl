use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName  = ".";
my $NameSpace = "root/cimv2";
my $WbemServices = Win32::OLE->GetObject("winmgmts://$ComputerName/$NameSpace");

my $Instance = $WbemServices->Get(__EventFilter)->SpawnInstance_();
$Instance->{Name}  = 'test';
$Instance->{QueryLanguage}   = 'WQL';

#onderstaande query kan ook zonder interne polling als je een "ExcentricEvent" gebruikt
$Instance->{Query} = qq[ SELECT * FROM __InstanceCreationEvent
     WITHIN 10
     WHERE TargetInstance ISA 'Win32_Process'
     AND (TargetInstance.Name = 'notepad.exe'
      OR  TargetInstance.Name = 'calc.exe') ];
$Filter = $Instance->Put_(wbemFlagUseAmendedQualifiers);
$Filterpad= $Filter->{path};

my $Instance = $WbemServices->Get(ActiveScriptEventConsumer)->SpawnInstance_();
$Instance->{Name}       = "test";
$Instance->{ScriptingEngine}       = "PerlScript";
$Instance->{ScriptText} = q[use Win32::OLE 'in';
  my $WbemServices = Win32::OLE->GetObject("winmgmts:{(Debug)}!//./root/cimv2");
  $_->Terminate foreach in $WbemServices->ExecQuery("Select * From Win32_Process
	 Where Name='$TargetEvent->{TargetInstance}->{Name}'
	and Creationdate<'$TargetEvent->{TargetInstance}->{Creationdate}'"); ];
$Consumer = $Instance->Put_(wbemFlagUseAmendedQualifiers);
$Consumerpad=$Consumer->{path};

my $Instance = $WbemServices->Get(__FilterToConsumerBinding)->SpawnInstance_();
$Instance->{Filter}   = $Filterpad;
$Instance->{Consumer} = $Consumerpad;
$Result = $Instance->Put_(wbemFlagUseAmendedQualifiers);
print $Result->{Path},"\n"; #ter controle

#indien je de events wilt groeperen wijzig je het script op 2 plaatsen :
$Instance->{Query} = qq[ SELECT * FROM __InstanceCreationEvent
     WITHIN 5
     WHERE TargetInstance ISA 'Win32_Process'
     AND (TargetInstance.Name = 'notepad.exe'
      OR  TargetInstance.Name = 'calc.exe') 
     GROUP WITHIN 10 by TargetInstance.Name];

$Instance->{ScriptText} = q[use Win32::OLE 'in'; 
    my $WbemServices = Win32::OLE->GetObject("winmgmts:{(Debug)}!//./root/cimv2");
#bepaal de handle van de meest recente
   foreach (in $WbemServices->ExecQuery("Select * From Win32_Process Where Name='$TargetEvent->{Representative}->{TargetInstance}->{Name}'")) {
       if (!$handle || ($_->{Creationdate} > $recent->{Creationdate})){
           $recent = $_;
           $handle = $_->{Handle};
       }
   }

   $query="Select * From Win32_Process Where Name='$TargetEvent->{Representative}->{TargetInstance}->{Name}' and Handle !=".$handle;
   $_->Terminate() foreach (in $WbemServices->ExecQuery($query));        
 ];


