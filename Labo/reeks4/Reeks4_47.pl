use Win32::OLE 'in';
$Win32::OLE::Warn = 3; #script stopt met foutmelding als er ergens iets niet lukt

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $ClassName = "Win32_Environment";

my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

my $Class = $WbemServices->Get($ClassName);
my $Instance = $Class->SpawnInstance_();

my $lijn = $ARGV[0];
my ($naam,$waarde)=split("=",$lijn);

#OF ingelezen waarden - let op met "\n" op einde van de lijn.
#chomp($_=<>);
#my ($naam,$waarde)=split "=";

$Instance->{UserName}     = "<SYSTEM>";
$Instance->{SystemVariable}= 1; #niet verplicht
$Instance->{Name}          = $naam;
$Instance->{VariableValue} = $waarde;
my $pad=$Instance->Put_();   #return-waarde is SWbemObjectPath van de nieuwe instantie

print "gelukt !\n" unless Win32::OLE->LastError();

print "Absolute path = ",$Instance->{path_}->{path},"\n"; #geen uitvoer
print "Absolute path = ",$Instance->{SystemProperties_}->Item("__PATH")->{Value},"\n"; #geen uitvoer
#lukt wel
print "return        = ",$pad->{path},"\n";                     

#relatieve pad lukt op drie manieren
print "Relative path = ",$Instance->{path_}->{relpath},"\n";                             
print "Relative path = ",$Instance->{SystemProperties_}->Item("__RELPATH")->{Value},"\n";
print "return        = ",$pad->{RelPath},"\n";


__DATA__
test=fliepie



