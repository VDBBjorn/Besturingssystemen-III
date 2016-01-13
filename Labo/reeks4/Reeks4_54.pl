use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
#de bovenliggende klasse van alle objecten die worden aangemaakt bij permanente eventregistratie
my $ClassName = "__IndicationRelated"; 
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

$_->Delete_() foreach in $WbemServices->InstancesOf($ClassName);
print Win32::OLE->LastError();


