use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName = ".";

my $WbemServices =  Win32::OLE->GetObject("winmgmts://$ComputerName/root/cimv2");
foreach my $ClassName (@ARGV) {
  my $Class=$WbemServices->Get($ClassName,wbemFlagUseAmendedQualifiers);
  print "\n$ClassName is Singleton" if isSetTrue ($Class,"Singleton");

}

#functie die nagaat of voor een bepaald object een bepaalde qualifier voorkomt, en zo ja of de waarde ingesteld is op True
sub isSetTrue{
  my ($Object,$prop)=@_;
  return  $Object->{Qualifiers_}->Item($prop) && $Object->{Qualifiers_}->Item($prop)->{Value};
}



