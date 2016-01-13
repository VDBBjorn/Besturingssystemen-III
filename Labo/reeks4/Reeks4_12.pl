use Win32::OLE 'in';

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $ClassName = "Win32_Environment";

my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

#directe methode
printf  "%s=%s [%s] [%s]\n",$_->{Name},$_->{VariableValue},$_->{UserName},$_->{SystemVariable}
	foreach sort {uc($a->{Name}) cmp uc($b->{Name})} in $WbemServices->InstancesOf($ClassName); #kan ook met WQL-query


