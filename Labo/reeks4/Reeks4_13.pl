use Win32::OLE 'in';
use Win32::OLE::Const;

my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");

%wd = %{Win32::OLE::Const->Load($Locator)}; 
my %types;

while (($type,$nr)=each (%wd)){
  if ($type=~/Cimtype/){
    $type=~s/wbemCimtype//g;
    $types{$nr}=$type;
  }
}

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
#my $ClassName = $ARGV[0]; 
my $ClassName = "Win32_SubDirectory";
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

my $Class=$WbemServices->Get($ClassName);
print $ClassName, " bevat ", $Class->{Properties_}->{Count}," properties en ", 
                             $Class->{SystemProperties_}->{Count}," systemproperties : \n\n";

foreach my $prop (in $Class->{Properties_}, $Class->{SystemProperties_}){
       print "\t",$prop->{Name}," (",$prop->{CIMType}, "/", $types{$prop->{CIMType}} , ($prop->{Isarray} ? " - is array" : ""),")\n";
}


