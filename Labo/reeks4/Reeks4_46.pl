use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName  = ".";
my $NameSpace = "root/cimv2";
my $ClassName = "Win32_Share";

my $WbemServices = Win32::OLE->GetObject("winmgmts://$ComputerName/$NameSpace");

my $Share = $WbemServices->Get($ClassName,wbemFlagUseAmendedQualifiers);

my $Methods=$Share->Methods_;
my %CreateReturnValues=maakHash_method_qualifier($Methods->Item("Create"));

#direct methode
$ReturnValue=$Share->Create( 'C:\examen',"Directexs share",0);
print $CreateReturnValues{$ReturnValue};

#formele methode
my $InParameters = $Methods->Item("Create")->InParameters;

$InParameters->{Description} = "New Share Description";
$InParameters->{Name} = "New bis Name";
$InParameters->{Path} = 'C:\DELL';
$InParameters->{Type} = 0;

$IntRc=$Share->ExecMethod_("Create", $InParameters);
print $CreateReturnValues{$IntRc->{ReturnValue}};

sub maakHash_method_qualifier{
   my $Method=shift;
   my %hash=();
   @hash{@{$Method->Qualifiers_(ValueMap)->{Value}}}
        =@{$Method->Qualifiers_(Values)->{Value}};
   return %hash;
}



