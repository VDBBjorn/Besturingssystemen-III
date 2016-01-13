use Win32::OLE 'in';

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

#Er zijn veel alternatieven mogelijk om het WMI-object te initialiseren, hier is een WQL-query gebruikt
my $Query="SELECT * FROM Win32_Environment WHERE Name ='Path' AND UserName !='<SYSTEM>'";
my $WbemObjectSet = $WbemServices->ExecQuery($Query);
#uniek WMI object ophalen
my ($WbemObject)=(in $WbemObjectSet);
print "oude waarde=",$WbemObject->{VariableValue},"**\n";

$add="C:\\temp";  # wat je wilt toevoegen
$WbemObject->{VariableValue}.=";$add";
$WbemObject->Put_();
print Win32::OLE->LastError(),"\n";


# Twee alternatieven met de formele methode :
#$WbemObject->{Properties_}->Item(ValiableValue)->{Value}=...
#$WbemObject->Properties_(ValiableValue)->{Value}=...



