use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

$|=1;

our $ComputerName = ".";
our $NameSpace = "root";

our $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");

sub GetNameSpaces {
    my $NameSpace = shift;
    my $WbemServices = $Locator->ConnectServer($ComputerName, $NameSpace);
    return if (Win32::OLE->LastError()); #indien geen connectie kan gemaakt worden met deze namespace

    my $Namespaces = $WbemServices->InstancesOf("__NAMESPACE", wbemQueryFlagShallow);
# of met een WQL-query :
#   my $Namespaces = $WbemServices->Execquery("select * from __NAMESPACE");

    my $InstancesAll = $WbemServices->Execquery("select * from meta_class"); 
    my $Instances = $WbemServices->SubclassesOf(); #is identiek met voorgaande

#enkel de eerste tak in de hierarchie
    my $InstancesDirect = $WbemServices->SubclassesOf(undef,wbemQueryFlagShallow); #undef beschrijft geen specifieke klasse

    printf "\n\n%3s #subklassen:\n\t onmiddelijk %3s < %3s = %s totaal",
             $NameSpace,$InstancesDirect->{Count},$InstancesAll->{Count},$Instances->{Count} ;

    return unless $Namespaces->{Count};
    GetNameSpaces("$NameSpace/$_") foreach sort {uc($a) cmp uc($b)} map {$_->{Name}} in $Namespaces;
}

GetNameSpaces($NameSpace);

#om alle namespaces te bepalen die de klasse StdRegProv bevatten voeg je nog volgende lus toe:
      foreach (in  $Instances)  
      {
           my $className=$_->SystemProperties_->Item("__RELPATH")->{Value};
           print "$className in $NameSpace\n" if ($className=~/StdRegProv/);
      }


