use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);


my $className =  "Win32_Process"; 
#Alle qualifiers ophalen 
my $Class =  $WbemServices->Get($className,wbemFlagUseAmendedQualifiers);

#Vergelijk met ophalen van Instance
#my $Instances=$Class->Instances_(wbemFlagUseAmendedQualifiers);
#print $Instances->{Count},"instances \n";
#($Class)=(in $Instances);
my $Methods = $Class->{Methods_};

printf "\n%s bevat %d methodes met volgende aanroep (en extra return-waarde):\n ", 
             $Class->{Path_}->{Class},$Methods->{Count};
foreach my $Method (sort {uc($a->{Name}) cmp uc($b->{Name})} in $Methods) {
    printf "\n\n\n------Methode %s ---(%s)-------------------- " ,$Method->{Name}, 
             $Method->{Qualifiers_}->{Count};
    foreach $qual (in $Method->{Qualifiers_}){    
        printf "\n%s: %s\n",$qual->{name},
                ref $qual->{value} eq "ARRAY" ? join " , ",@{$qual->{Value}} : $qual->{Value};
    }    
}



