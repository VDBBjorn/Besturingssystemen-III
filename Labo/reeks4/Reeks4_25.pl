use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName = ".";
my $WbemServices =  Win32::OLE->GetObject("winmgmts://$ComputerName/root/cimv2");

#bepaal alle klassen in de namespace. Je kan dit niet efficienter - een beperking op de qualifier lukt niet
my $Classes = $WbemServices->SubclassesOf(undef,wbemFlagUseAmendedQualifiers);
#Ander alternatief
#my $Classes = $WbemServices->Execquery("select * from meta_class","WQL",wbemFlagUseAmendedQualifiers);

#functie die nagaat of voor een bepaald object een bepaalde qualifier voorkomt, en zo ja of de waarde ingesteld is op True
sub isSetTrue{
  my ($Object,$prop)=@_;
  return  $Object->{Qualifiers_}->Item($prop) && $Object->{Qualifiers_}->Item($prop)->{Value};
}

my %providers;

foreach my $Class (in $Classes) {
   if ($Class->{Qualifiers_}->Item("Provider"))
     {
        $providers{$Class->{Qualifiers_}->Item("Provider")->{Value}}++;
      #  print $Class->{Qualifiers_}->Item("Provider")->{Value},"\n";
     }
   else
     {
         $providers{"Ontbreekt"}++;
     }
}

foreach (sort {$providers{$b}  <=> $providers{$a}}  keys %providers)
  {
    print $_,":",$providers{$_},"\n";
}


