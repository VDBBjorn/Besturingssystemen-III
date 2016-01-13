use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName = ".";
my $WbemServices =  Win32::OLE->GetObject("winmgmts://$ComputerName/root/cimv2");
my $Classes = $WbemServices->SubclassesOf(undef,wbemFlagUseAmendedQualifiers);
#Ander alternatief
#my $Classes = $WbemServices->Execquery("select * from meta_class","WQL",,wbemFlagUseAmendedQualifiers);

my $Abstract = 0;
my $nonAbstract = 0;
my $Association = 0;
my $nonAssociation = 0;
my $Dynamic = 0;
my $nonDynamic = 0;
my $Singleton = 0;
my $nonSingleton = 0;

#functie die nagaat of voor een bepaald object een bepaalde qualifier voorkomt, en zo ja of de waarde ingesteld is op True
sub isSetTrue{
  my ($Object,$prop)=@_;
  return  $Object->{Qualifiers_}->Item($prop) && $Object->{Qualifiers_}->Item($prop)->{Value};
}

foreach my $Class (in $Classes) {
    isSetTrue($Class,"Abstract")    and $Abstract++    or $nonAbstract++;
    isSetTrue($Class,"Association") and $Association++ or $nonAssociation++;
    isSetTrue($Class,"Dynamic")     and $Dynamic++     or $nonDynamic++;
    isSetTrue($Class,"Singleton")   and $Singleton++   or $nonSingleton++;
}

printf "Abstract:   %5d (+)%5d (-)\n",$Abstract   ,$nonAbstract;
printf "Association:%5d (+)%5d (-)\n",$Association,$nonAssociation;
printf "Dynamic:    %5d (+)%5d (-)\n",$Dynamic    ,$nonDynamic;
printf "Singleton:  %5d (+)%5d (-)\n",$Singleton  ,$nonSingleton;


