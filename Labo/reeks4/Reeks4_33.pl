use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting'; #inladen van de WMI constanten

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

my $ClassName="Win32_NetworkAdapter"; #zonder argument
#my $ClassName = $ARGV[0]; 

my $Class=$WbemServices->Get($ClassName,wbemFlagUseAmendedQualifiers);
print "De attributen met ValueMap voor de klasse ",$ClassName,"\n\n";

#enkel specifieke attributen
foreach my $prop (in $Class->{Properties_}){
  my $Qualifiers = $prop->{Qualifiers_};
  if ($Qualifiers->{ValueMap}){
     print "\n",$prop->{name} ;
     print "\nDescription : ",$Qualifiers->Item("Description")->{Value} ;
     my %hash;
     @hash{@{$Qualifiers->Item("ValueMap")->{Value}}} = @{$Qualifiers->Item("Values")->{Value}}; #koppelen in een hash
     while (($key,$value)=each(%hash)){ 
        printf "\n %30s: %s",$key,$value;
     }
     print "\n----------------------------------------------";
  }
}


