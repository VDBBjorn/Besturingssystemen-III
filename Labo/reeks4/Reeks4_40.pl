#enkel processen opgestart in de huidige context worden afgebroken

use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName = '.';
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

my $Methods = $WbemServices->Get("Win32_Process",wbemFlagUseAmendedQualifiers)->{Methods_};

my %TerminateReturnValues=maakHash_method_qualifier($Methods->Item("Terminate"));

my $ProcessName = "notepad.exe";

foreach (in $WbemServices->ExecQuery("Select * From Win32_Process Where Name='$ProcessName'")){
     $ReturnValue=$_->Terminate() ; #(1)directe methode
     print $_->{Handle},": ",$TerminateReturnValues{$ReturnValue},"\n";

   }


sub maakHash_method_qualifier{
   my $Method=shift;
   my %hash=();
   @hash{@{$Method->Qualifiers_(ValueMap)->{Value}}}
        =@{$Method->Qualifiers_(Values)->{Value}};
   return %hash;
}

#met formele methode
#vooraf de invoerparameters initialiseren is NOODZAKELIJK, omdat "reason" een verplichte parameter is

#(1) vervangen door formele aanroep:
     # my $MethodInParameters =$Methods->{"Terminate"}->{InParameters}; #Moeten echter niet ingevuld worden
     # my $MethodOutParameters=$_->ExecMethod_("Terminate",$MethodInParameters) ;
     # $ReturnValue=$MethodOutParameters->{ReturnValue};




