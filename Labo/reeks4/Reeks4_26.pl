use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName = ".";

my $WbemServices =  Win32::OLE->GetObject("winmgmts://$ComputerName/root/cimv2");
my $ClassName = $ARGV[0];  #test dit uit met Win32_LocalTime, Win32_DiskDrive en Win32_Product

print "\n$ClassName\n";
my $Class=$WbemServices->Get($ClassName,wbemFlagUseAmendedQualifiers);
#my $Class=$WbemServices->Get($ClassName);  #Geeft minder qualifiers
foreach $Qualifier (in $Class->Qualifiers_){
    $waarde=$Qualifier->Value;
    print "\t",$Qualifier->Name,"(",ref($waarde) eq "ARRAY"  ? "Array=".join (",",@{$waarde}) : $waarde,")\n";
  }


#Ophalen van alle instanties kan heel lang duren... vb bij Win32_Product
my $Instances = $Class->Instances_(wbemFlagUseAmendedQualifiers);
my ($Instance)=(in $Instances);

print "\n",$Instance->{Path_}->{relpath},"\n";
foreach $Qualifier (in $Instance->Qualifiers_){ #geeft een kortere lijst van qualifiers
    $waarde=$Qualifier->Value;
    print "\t",$Qualifier->Name,"(",ref($waarde) eq "ARRAY"  ? "Array=".join (",",@{$waarde}) : $waarde,")\n";
  }


