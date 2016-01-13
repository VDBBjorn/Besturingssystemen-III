use Win32::OLE 'in';

my $ComputerName = '.';
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

my $typeLib=Win32::OLE::Const->Load($WbemServices);    #inladen van bijhorende typeLib

%cimtype;
while ( ( $key, $value ) = each %{$typeLib} ) {
 {
    $cimtype{$value}=substr($key,11) if ($key=~/wbemCim/);
  }
}


my $ClassName = $ARGV[0]; 
my $Class=$WbemServices->Get($ClassName,wbemFlagUseAmendedQualifiers);

print "De Property Qualifiers van alle attributen van de klasse ",$ClassName,"\n\n";
foreach my $prop (in $Class->{Properties_}){ #enkel de properties die specifiek zijn voor de klasse
    my $Qualifiers = $prop->{Qualifiers_};
    printf "\n\n%s",$prop->{Name};
    if ($Qualifiers->Item("CIMTYPE")){
        printf " (%s <->%s = %s)",$prop->{CIMType},$Qualifiers->Item("CIMTYPE")->{Value},$cimtype{$prop->{CIMType}};     #de attribuutqualifiers bevat een duidelijke naam voor het type
      }
    printf "\n   Qualifiers: %s", join(" ",map {$_->{Name}} in $Qualifiers);
}



