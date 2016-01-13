use Win32::OLE 'in';

my $ComputerName = ".";
my $WbemServices =  Win32::OLE->GetObject("winmgmts://$ComputerName/root/cimv2");
my $Classes = $WbemServices->SubclassesOf();
#Ander alternatief
#my $Classes = $WbemServices->Execquery("select * from meta_class");


allClasses();
assocClasses();

sub allClasses {
  foreach my $Class ( in $Classes) {
    #zoek de properties waarvoor de qualifier"Key" is ingesteld
    my @Keys = map {$_->{Name}} grep {isSetTrue($_,"Key")} in $Class->{Properties_};

    printf ("%-42s(%d): %s\n",$Class->{Path_}->{RelPath}, scalar @Keys, (join ",",@Keys))  if @Keys>1;
  }
}


#Aanpassing voor associatorklassen
sub assocClasses{
  foreach my $Class ( in $Classes) {
    next unless isSetTrue($Class,"Association"); #enkel Associatorklassen

    #zoek de properties waarvoor de qualifier"Key" is ingesteld en bepaal alle info
    my @Keys = map {info($_)} grep {isSetTrue($_,"Key")} in $Class->{Properties_};

    printf ("%-42s(%d): %s\n",$Class->{Path_}->{RelPath}, scalar @Keys, (join ",",@Keys))  if @Keys>1;
  }
}

#gaat na of voor een bepaald object een bepaalde qualifier voorkomt, en zo ja of de waarde ingesteld is op True
sub isSetTrue{
  my ($Object,$prop)=@_;
  return  $Object->{Qualifiers_}->Item($prop) && $Object->{Qualifiers_}->Item($prop)->{Value};
}

#functie die de naam en het CIMTYPE ophaalt
sub info{
   $res  = $_->{Name};
   $cimtype = $_->{Qualifiers_}->Item("CIMType")->{Value};
   return $res."(".$cimtype.")";
 }

#Merk op dat een associatorklasse altijd 2 sleutelattributen heeft, die beiden een ref-type zijn.
#Dit ref-type bevat de naam van de klasse die geassocieerd wordt 



