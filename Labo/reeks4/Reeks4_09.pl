use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

#indien de zesde optionele parameter niet wordt ingesteld bekom je een lege set van "instanties"
my $Associators = $WbemServices->AssociatorsOf("Win32_Directory",undef,undef,undef,undef,undef,1);
#OF
#my $Class = $WbemServices->Get("Win32_Directory");
#my $Associators = $Class->Associators_(undef,undef,undef,undef,undef,1);

print $Associators->{Count} , " exempla(a)r(en) \n";




