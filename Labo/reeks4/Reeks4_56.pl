use Win32::OLE 'in';

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
#test vooraf onderstaande query in WbemTest
my $NotificationQuery = "SELECT * FROM __InstanceModificationEvent WITHIN 5 
                          WHERE TargetInstance ISA 'Win32_Service'";

my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);
my $EventNotification = $WbemServices->ExecNotificationQuery($NotificationQuery);

$|=1; 
print "Waiting for events .";

while(1) {
my $Event = $EventNotification->NextEvent(5000);

Win32::OLE->LastError() 
     and print "." 
      or printf "\n%s changed from %s to %s\n"
	,$Event->{TargetInstance}->{DisplayName}
	,$Event->{PreviousInstance}->{State}
	,$Event->{TargetInstance}->{State};
}

