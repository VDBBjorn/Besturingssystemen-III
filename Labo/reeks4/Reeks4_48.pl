#verwijdering specifieke share:

use Win32::OLE 'in';
$Win32::OLE::Warn = 3; #script stopt met foutmelding als er ergens iets niet lukt

my $ComputerName  = ".";
my $NameSpace = "root/cimv2";
my $ClassName = "Win32_Share";
my $KeyName = "Name";
my $KeyValue = "New Share Name";
my $WbemServices = Win32::OLE->GetObject("winmgmts://$ComputerName/$NameSpace");

$WbemServices->Get("$ClassName.$KeyName='$KeyValue'")->Delete();

#verwijdering specifieke environment variabele:

use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $ClassName = "Win32_Environment";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

chomp ($_=<>);
$WbemServices->Get($ClassName . ".UserName='<SYSTEM>',Name='$_'")->Delete_;
__DATA__
test


