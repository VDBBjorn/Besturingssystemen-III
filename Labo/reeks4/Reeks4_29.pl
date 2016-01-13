use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting '; #kan weggelaten worden

my $ComputerName = ".";
my $WbemServices =  Win32::OLE->GetObject("winmgmts://$ComputerName/root/cimv2");
my $Classes = $WbemServices->SubclassesOf();
#het is niet nodig om de constante toe te voegen, 
#my $Classes = $WbemServices->SubclassesOf(undef,wbemFlagUseAmendedQualifiers);

#Ander alternatief
#my $Classes = $WbemServices->Execquery("select * from meta_class");

my %Info;

foreach my $Class (in $Classes) {
 
  if ($Class->{Qualifiers_}->Item("CreateBy")) {
    push @{$Info{$Class->{Path_}->{Relpath}}},$Class->{Qualifiers_}->Item("CreateBy")->{Value};

  }
  if (($Class->{Qualifiers_}->Item("DeleteBy"))) {
      push @{$Info{$Class->{Path_}->{Relpath}}},$Class->{Qualifiers_}->Item("DeleteBy")->{Value};

    }
 
}
while (($class,$value)=each(%Info)) { 
  printf "\n%s:\n\t%s",$class,join("\n\t",@{$value});
}


