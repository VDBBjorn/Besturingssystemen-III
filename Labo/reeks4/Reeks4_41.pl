use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';
my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $ClassName = "Win32_Service";
my $InstanceName = "Dhcp"; #vul zelf een service-naam in

my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);
my $Instance = $WbemServices->Get("$ClassName='$InstanceName'");

printf "%s is currently %s\n" ,$Instance->{DisplayName},$Instance->{State};

my $Methods = $WbemServices->Get($ClassName,wbemFlagUseAmendedQualifiers)->{Methods_};

my %StartServiceReturnValues=maakHash_method_qualifier($Methods->Item("StartService"));
my %StopServiceReturnValues=maakHash_method_qualifier($Methods->Item("StopService"));

if ( $Instance->{State} eq "Stopped" ) {
   #formele methode
   my $OutParameters = $Instance->ExecMethod_("StartService"); #geen invoerparameters
   my $intRC = $OutParameters->{ReturnValue};
   print ($intRC ? "Execution failed: " . $StartServiceReturnValues{$intRC} : $Instance->{DisplayName} . " started") , "\n";
}
else {
   #directe methode
   $intRC=$Instance->StopService();  
   print ($intRC ? "Execution failed: " . $StopServiceReturnValues{$intRC} : $Instance->{DisplayName} . " stopped") , "\n" ;
}

sub maakHash_method_qualifier{
   my $Method=shift;
   my %hash=();
   @hash{@{$Method->Qualifiers_(ValueMap)->{Value}}}
        =@{$Method->Qualifiers_(Values)->{Value}};
   return %hash;
}

