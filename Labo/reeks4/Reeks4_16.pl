use Win32::OLE 'in';
use Win32::OLE::Variant;

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

my $DateTime = Win32::OLE->new("WbemScripting.SWbemDateTime");
my $ClassName="Win32_OperatingSystem";

my $instances=$WbemServices->InstancesOf($ClassName);
print $instances->{Count},"\n";
#Het unieke element ophalen
my ($instance)=in $instances; 

print "\n------------Formele methode ------\n";
foreach my $attributeName (@ARGV){
  $prop=$instance->Properties_->Item($attributeName); #lukt enkel met gewone attributen, niet met systeemattributen 
# $prop=$instance->Properties_($attributeName); #korte notatie
  if ($prop->{CIMType} == 101){
       $DateTime->{Value} = $prop->{Value};     
       printf "%-42s : %s \n",$prop->{Name},$DateTime->GetVarDate;
  }
  else {
      printf "%-42s :%s %s \n", $prop->{Name},
             ($prop->{Isarray} ? "(ARRAY)" : "",
             ($prop->{Isarray} ? join ",",@{$prop->{Value}} : $prop->{Value}));
  }
}

print "\n------------Directe methode ------\n";
foreach my $attributeName ( @ARGV){
  my $value=$instance->{$attributeName};  #lukt enkel met gewone attributen, niet met systeemattributen 
  printf "%-42s : %s  \n",$attributeName, (ref( $value ) eq "ARRAY"  ? join ",",@{$value}  : $value );
}



#systeemattribuut __RELPATH ophalen - formele methode
printf "%-42s : %s \n","Relatief pad",$instance->SystemProperties_->Item("__RELPATH")->{Value}; 



