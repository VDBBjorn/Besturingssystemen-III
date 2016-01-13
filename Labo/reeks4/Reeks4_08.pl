use Win32::OLE 'in';
#$Win32::OLE::Warn = 3;  #niet toevoegen, anders stopt het script bij een fout

our $ComputerName = ".";
our $NameSpace = "root";
our $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");

sub GetNameSpaces {
    my $NameSpace = shift;
    print $NameSpace , "\n";
    my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);
    return if (Win32::OLE->LastError()); #indien geen connectie kan gemaakt worden met deze namespace

    my $Instances = $WbemServices->InstancesOf("__NAMESPACE");
# of met een WQL-query :
#   my $Instances = $WbemServices->Execquery("select * from __NAMESPACE");

    return unless $Instances->{Count};
#de naam van de Namespace moet worden opgebouwd, zodat het connecteren zal lukken.
    GetNameSpaces("$NameSpace/$_") foreach sort {uc($a) cmp uc($b)} map {$_->{Name}} in $Instances;
}
GetNameSpaces($NameSpace);


