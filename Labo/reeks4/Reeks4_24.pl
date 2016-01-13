use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName = ".";
my $NameSpace = "root/cimv2";
#my $NameSpace = "root/msapps12";

my $ClassName = "";
#my $ClassName = "__EventGenerator"; #om snel te testen
my $Level=($ClassName ? -1 : -2);

my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");
my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);

GetSubClasses($ClassName,$Level);

sub GetSubClasses {
    my ($ClassName,$Level) = @_;
    $Level++;
    print "\n","\t" x $Level , $ClassName  if $ClassName;

    my $Instances = $WbemServices->SubClassesOf($ClassName, wbemQueryFlagShallow); #onmiddelijke subklassen
    GetSubClasses($_,$Level) foreach sort {uc($a) cmp uc($b)} map {$_->{Path_}->{RelPath}} in $Instances;
}



