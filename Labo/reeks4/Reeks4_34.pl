use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting';

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

#maakt een hashmap met de value - waarde koppels van het attribuut
sub maakHash{
  my ($prop,$Classnaam)=@_;
  my $Class = $WbemServices->Get($Classnaam,wbemFlagUseAmendedQualifiers);
  my $Qualifiers = $Class->Properties_($prop)->{Qualifiers_};
  my %hash=();
  @hash{@{$Qualifiers->Item("ValueMap")->{Value}}} = @{$Qualifiers->Item("Values")->{Value}};
  return %hash;
}

#op klassen de hash initialiseren
%Availability        = maakHash("Availability","Win32_NetworkAdapter");
%NetConnectionStatus = maakHash("NetConnectionStatus","Win32_NetworkAdapter");

my $Query="SELECT * FROM Win32_NetworkAdapter WHERE NetConnectionStatus>=0"); 
my $AdapterInstances = $WbemServices->Execquery($Query);   #(*)

foreach $AdapterInstance (sort {uc($a->{NetConnectionID}) cmp uc($b->{NetConnectionID})} in $AdapterInstances) {
    print "******************************************************** \n";
    printf "%s: %s\n", "Connection Name", $AdapterInstance->{NetConnectionID};

    printf "%s: %s\n", "Adapter name", $AdapterInstance->{Name};
    printf "%s: %s\n", "Device availability", $Availability{$AdapterInstance->{Availability}};
    printf "%s: %s\n", "Adapter type", $AdapterInstance->{AdapterType};
    printf "%s: %s\n", "Adapter state", $NetConnectionStatus{$AdapterInstance->{NetConnectionStatus}};
    printf "%s: %s\n", "MAC address", $AdapterInstance->{MACAddress};
    printf "%s: %s\n", "Adapter service name", $AdapterInstance->{ServiceName};
    printf "%s: %s\n", "Last reset", $AdapterInstance->{TimeOfLastReset};

    #Recource Informatie
    $Query="ASSOCIATORS OF {Win32_NetworkAdapter='$AdapterInstance->{Index}'} 
               WHERE AssocClass=Win32_AllocatedResource";
    my $AdapterResourceInstances = $WbemServices->ExecQuery ($Query);
    foreach $AdaptResInstance (in $AdapterResourceInstances) {
        my $className=$AdaptResInstance->{Path_}->{Class};
        printf "%s: %s\n", "IRQ resource", $AdaptResInstance->{IRQNumber} if $className eq "Win32_IRQResource";
        printf "%s: %s\n", "DMA channel", $AdaptResInstance->{DMAChannel} if $className eq "Win32_DMAChannel";
        printf "%s: %s\n", "I/O Port", $AdaptResInstance->{Caption}       if $className eq "Win32_PortResource";
        printf "%s: %s\n", "Memory address", $AdaptResInstance->{Caption} if $className eq "Win32_DeviceMemoryAddress";
    }

    my $AdapterInstance = $WbemServices->Get ("Win32_NetworkAdapterConfiguration=$AdapterInstance->{Index}");
    next unless $AdapterInstance->{IPEnabled};

    if ($AdapterInstance->{DHCPEnabled}) {
       printf "%s: %s\n", "DHCP expires", $AdapterInstance->{DHCPLeaseExpires};
       printf "%s: %s\n", "DHCP obtained", $AdapterInstance->{DHCPLeaseObtained};
       printf "%s: %s\n", "DHCP server", $AdapterInstance->{DHCPServer};
    }

    printf "%s: %s\n", "IP address(es)", (join ",",@{$AdapterInstance->{IPAddress}});
    printf "%s: %s\n", "IP mask(s)", (join ",",@{$AdapterInstance->{IPSubnet}});
    printf "%s: %s\n", "IP connection metric", $AdapterInstance->{IPConnectionMetric};
    printf "%s: %s\n", "Default Gateway(s)",(join ",",@{$AdapterInstance->{DefaultIPGateway}});
    printf "%s: %s\n", "Dead gateway detection enabled", $AdapterInstance->{DeadGWDetectEnabled};

    printf "%s: %s\n", "DNS registration enabled", $AdapterInstance->{DomainDNSRegistrationEnabled};
    printf "%s: %s\n", "DNS FULL registration enabled", $AdapterInstance->{FullDNSRegistrationEnabled};
    printf "%s: %s\n", "DNS search order", (join ",",@{$AdapterInstance->{DNSServerSearchOrder}});
    printf "%s: %s\n", "DNS domain", $AdapterInstance->{DNSDomain};
    printf "%s: %s\n", "DNS domain suffix search order", $AdapterInstance->{DNSDomainSuffixSearchOrder};
    printf "%s: %s\n", "DNS enabled for WINS resolution", $AdapterInstance->{DNSEnabledForWINSResolution};
}
#Andere oplossing zonder query . Vervang in (*)  ->execquery door:

#my $AdapterInstances = $WbemServices->InstancesOf("Win32_NetworkAdapter");

#foreach $AdapterInstance (sort {uc($a->{NetConnectionID}) cmp uc($b->{NetConnectionID})} in $AdapterInstances) {
#    next unless defined $AdapterInstance->{NetConnectionStatus};
#....


