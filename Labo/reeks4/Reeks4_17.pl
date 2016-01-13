use Win32::OLE 'in';

my $ComputerName = ".";

#deze lijst meegeven voor de klassen
#@ARGV = ("Win32_LocalTime","Win32_Group", "Win32_Process");

#mogelijke argumenten voor de instanties - zorg dat de instantie bestaat
@ARGV = ("Win32_LocalTime=@",
         "Win32_Group.Domain='VIVALDI',Name='Gebruikers'", #wijzig naar je eigen computer
         "Win32_Process.Handle='3596'");   #vul een bestaand HandleId in
my $WbemServices =  Win32::OLE->GetObject("winmgmts://$ComputerName/root/cimv2");
my @properties=("Authority","Class","DisplayName","IsClass", "IsSingleton","Keys","Local","Namespace","ParentNamespace", "Path","RelPath","Server"); # Security_ niet in de lijst


foreach  (@ARGV) {
  print "\n*********$_***************************************";
  my $object=$WbemServices->Get($_);

  for my $prop (@properties) {
    $waarde=$object->{Path_}->{$prop};     
    if (ref($waarde)) {
      if (Win32::OLE->QueryObjectType($waarde) =~ /Set/) {
        print "\n$prop heeft ",$waarde->{Count} ," values";
        for (in $waarde) {
          printf "\n\t%s = %s", $_->{Name},$_->{Value};
        }

      }
    } else {
      print "\n$prop = $waarde";
    }
  }
 
  print "\n";
}
#opmerking: Niet alle properties zijn correct ingevuld. IsSingleton is altijd 0



