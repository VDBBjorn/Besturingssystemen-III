use Win32::OLE 'in';

@ClassNames=qw(Win32_PerfFormattedData_PerfOS_System Win32_PerfFormattedData_PerfOS_Processor Win32_PerfFormattedData_PerfDisk_LogicalDisk Win32_PerfFormattedData_PerfOS_Memory);

my $ComputerName = ".";
my $NameSpace = "root/cimv2";

my $Refresher=Win32::OLE->new("WbemScripting.SWbemRefresher");
my $Locator  =Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

foreach my $ClassName (@ClassNames) {
    $WbemServices->Get($ClassName)->Qualifiers_("Singleton") && $WbemServices->Get($ClassName)->Qualifiers_("Singleton")->{Value}
    ? $Refresher->Add($WbemServices, $ClassName . "=@")->{Object}
    : $Refresher->AddEnum($WbemServices, $ClassName)->{ObjectSet} ;
}
print "Number of items in the refresher is " , $Refresher->{Count} , "\n";

$Refresher->{AutoReconnect} = True;

while (1) {
    print "*********************************************\n";
    $Refresher->Refresh();
    foreach $RefreshableItem (in $Refresher) {
       if ( $RefreshableItem->{IsSet}) {
            foreach my $Instance (in $RefreshableItem->{ObjectSet}) {
                toonprop ($Instance);
            }
       }
       else {
            toonprop ($RefreshableItem->{Object});
        }
    }
    sleep(20);
    # of
    #Win32::Sleep(20000);#in milliseconden
}

sub toonprop{
  my ($Object)=@_;
  print $Object->{Path_}->{Path} , "\n";
  foreach my $Property (in $Object->{Properties_}) {
       next unless defined $Property->{Value};
     printf "%-30s %s\n",$Property->{Name}
   	 , ref( $Property->{Value} ) eq "ARRAY"
	  	 ? join ",",@{$Property->{Value}}
		 : $Property->{Value};
  }
}



