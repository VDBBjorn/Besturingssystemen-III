use Win32::OLE 'in';
use Win32::OLE::Const 'Microsoft WMI Scripting ';

my $ComputerName = ".";
my $WbemServices =  Win32::OLE->GetObject("winmgmts://$ComputerName/root/cimv2");

#bepaal alle klassen in de namespace.
my $Classes = $WbemServices->SubclassesOf(undef,wbemFlagUseAmendedQualifiers);
#Ander alternatief - qualifier kan je niet specifieren in een WQL-query
#my $Classes = $WbemServices->Execquery("select * from meta_class","WQL",wbemFlagUseAmendedQualifiers);

#gaat na of voor een bepaald object een bepaalde qualifier voorkomt, en zo ja of de waarde ingesteld is op True
sub isSetTrue{
  my ($Object,$prop)=@_;
  return  $Object->{Qualifiers_}->Item($prop) && $Object->{Qualifiers_}->Item($prop)->{Value};
}

foreach my $Class ( in $Classes) {
  next unless isSetTrue($Class,"Association");  #enkel Associatorklassen
  next if     isSetTrue($Class,"Abstract");     #geen abstracte klassen
  my @Keys = ();
  my @Types= ();
  foreach my $Property (in $Class->{Properties_}) {
    #zoek de 2 unieke sleutelattributen
    if (isSetTrue($Property,"Key")){
      #onthoud de naam van het sleutelattribuut
       push @Keys ,$Property->{Name};
      #de CIMTYPE-attribuutqualifier bevat de naam van de klasse die kan gekoppeld worden met dit sleutelattribuut
       push @Types,substr($Property->{Qualifiers_}->Item("CIMType")->{Value},4); #verwijder ref:
       last if @Keys==2;
    }
  }
  printf ("%-21s via %-28s(%s)\n", $Types[0], $Class->{Path_}->{RelPath}, (join ",",@Keys)) 
              if (@Types==2 && $Types[0] eq $Types[1]);
}


