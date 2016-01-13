use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName = ".";
my $NameSpace = "root/cimv2";

my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

my $Class = $WbemServices->Get(Win32_LogicalDisk,wbemFlagUseAmendedQualifiers);

#maakt een hashmap met de value - waarde koppels van het attribuut
sub maakHash{
  my ($prop,$Classnaam)=@_;
  my $Class = $WbemServices->Get($Classnaam,wbemFlagUseAmendedQualifiers);
  my $Qualifiers = $Class->Properties_($prop)->{Qualifiers_};
  my %hash=();
  @hash{@{$Qualifiers->Item("ValueMap")->{Value}}} = @{$Qualifiers->Item("Values")->{Value}};
  return %hash;
}



my @DriveType = @{$Class->Properties_(DriveType)->Qualifiers_(Values)->{Value}}; #onthouden 
my @MediaType_LogicalDrive = @{$Class->Properties_(MediaType)->Qualifiers_(Values)->{Value}}; #onthouden

my $Class = $WbemServices->Get(Win32_DiskDrive,wbemFlagUseAmendedQualifiers);
my @Capabilities = @{$Class->Properties_(Capabilities)->Qualifiers_(Values)->{Value}};

# MediaType heeft zowel Values als ValueMap - mechanisme 
%MediaType_DiskDrive=maakHash("MediaType","Win32_DiskDrive");

my $Instances = $WbemServices->InstancesOf("Win32_DiskPartition");

foreach $Instance (in $Instances) {
    printf "*************************************** %s: %s\n", "DeviceID", $Instance->{DeviceID};
    my $Properties = $Instance->{Properties_};

    defined $_->{Value}
       && printf "%s: %s\n",$_->{Name}, ref($_->{Value}) eq "ARRAY" ? join(",",@{$_->{Value}}) : $_->{Value}
            foreach in $Properties;

    print "\n";
    $Query="ASSOCIATORS OF {Win32_DiskPartition='$Instance->{DeviceID}'} 
            WHERE AssocClass=Win32_DiskDriveToDiskPartition";

    foreach $PhysicalDiskInstance (in $WbemServices->ExecQuery($Query)) {
        my $Properties = $PhysicalDiskInstance->{Properties_};  #haalt ook de waarden op
        foreach $Property (in $Properties) {
            if  ($Property->{Name} eq "Capabilities") {
            	printf "%s: %s\n",$Property->{Name}, join(",",map {$Capabilities[$_]} @{$Property->{Value}});
            }
            elsif  ($Property->{Name} eq "MediaType") {
                $value=$Property->{Value};
                $value=~s/[\t]/ /g;  #tab-teken in plaats van een spatie !!
             	printf "%s: (%s) %s\n", $Property->{Name},$Property->{Value},$MediaType_DiskDrive{$value};
           }
            else {
                printf "%s: %s\n", $Property->{Name}, 
                      ref( $Property->{Value} ) eq "ARRAY" ? join(",",@{$Property->{Value}}) : $Property->{Value}
                   if defined $Property->{Value};
            }
        }
    }

    print "\n";
    $Query="ASSOCIATORS OF {Win32_DiskPartition='$Instance->{DeviceID}'} 
               WHERE AssocClass=Win32_LogicalDiskToPartition";
    foreach $LogicalDiskInstance (in $WbemServices->ExecQuery($Query)) {
        my $Properties = $LogicalDiskInstance->{Properties_};   #haalt ook de waarden op
        foreach $Property (in $Properties) {
            if  ($Property->{Name} eq "DriveType") {
            	printf "%s: %s\n", $Property->{Name}, $DriveType[$Property->{Value}];

            }
            elsif  ($Property->{Name} eq "MediaType") {
            	printf "%s: %s\n", $Property->{Name}, $MediaType_LogicalDrive[$Property->{Value}];
            }
            else {
                printf "%s: %s\n", $Property->{Name}, 
                      ref( $Property->{Value} ) eq "ARRAY" ? join ",",@{$Property->{Value}} : $Property->{Value}
                   if defined $Property->{Value};
            }
        } 
    }
}



