use Win32::OLE qw(in);
#use Win32::OLE::Const ".*WMI";
use Win32::OLE::Const "Microsoft WMI Scripting";
$|=1;

my $services = ConnectServer();
my $classname = "Win32_Process";
my $instancename = "notepad.exe";

$query = "select * from win32_process where name='notepad.exe'";

my $Methods = $services->Get("Win32_Process",wbemFlagUseAmendedQualifiers)->{Methods_};

my %TerminateReturnValues=MaakHash_method_qualifier($Methods->Item("Terminate"));


foreach my $process (in $services->ExecQuery("select * from win32_process where name='notepad.exe'")) {
	$returnvalue = $process->Terminate();
	print $process->{handle},": ",$TerminateReturnValues{$returnvalue},"\n";
}

# Gets the underlying namespaces for a given server
# arguments: namespace
sub GetNameSpaces {
	my $namespace = shift;
	print "$namespace \n";
	my $services = ConnectServer(".",$namespace);
	return if (Win32::OLE->LastError());
	my $instances = $services->instancesof("__NAMESPACE");
	return unless $instances->{Count};
	GetNameSpaces("$namespace/$_") foreach sort{uc($a) cmp uc($b)} map {$_->{Name}} in $instances;
}

# connects to server
# arguments: computername, namespace to connect
sub ConnectServer { 
	my $locator = Win32::OLE->new("WbemScripting.SWbemLocator");
	my $computerName=shift || ".";
	my $nameSpace=shift || "root/cimv2";
	my $services = $locator->connectserver($computerName,$nameSpace);
	#print "connectie gelukt!\n" if ref($services);
	return $services;
}

# gets all intances of class
# arguments: wbemServices, instancename
sub GetInstances {
	my $services = shift;
	my $instanceName = shift;
	my $instances = $services->instancesof($instanceName);
	return $instances;
}

sub IsSetTrue {
	my ($object,$prop) = @_;
	return $object->{qualifiers_}->item($prop) && $object->{qualifiers_}->item($prop)->{value};
}

sub MaakHash {
	my ($services,$prop,$classname) = @_;
	my $class = $services->get($classname,wbemFlagUseAmendedQualifiers);
	my $qualifiers = $class->{properties_}->item($prop->{name})->{qualifiers_};	
	my %hash;
	if($qualifiers->item("valuemap")) {
		@hash{@{$qualifiers->item("valuemap")->{value}}} = @{$qualifiers->item("values")->{value}};
	}
	return %hash;
}

sub MaakHash_method_qualifier {
	my ($method) = shift;
	my %hash=();
	@hash{@{$method->qualifiers_(valuemap)->{value}}} = @{$method->{qualifiers_}->item("values")->{value}};
	return %hash;
}