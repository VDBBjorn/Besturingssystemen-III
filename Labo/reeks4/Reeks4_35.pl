use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting'; #inladen van de WMI constanten

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

my $ClassName="Win32_LogicalDisk"; #zonder argument
#my $ClassName = $ARGV[0]; 

my $Class=$WbemServices->Get($ClassName,wbemFlagUseAmendedQualifiers);

print $Class->{Properties_}->{Count}," attributen voor de klasse $ClassName \n";
print "De attributen met enkel Values, en geen ValueMap:\n";

foreach my $prop (in $Class->{Properties_}) {
  my $Qualifiers = $prop->{Qualifiers_};
 
  if ( $Qualifiers->Item(Values) && !$Qualifiers->Item(ValueMap)) {
    print "\n\n",$prop->{name};
    my $i=0; #nummering begint op 0
    foreach (@{$Qualifiers->Item(Values)->{Value}}) {
      print "\n\t$i:",$_;
      $i++;
    }
  }
}

