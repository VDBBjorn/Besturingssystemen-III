# implementatie bind_object functie: zie sectie 5

$abstractSchema = bind_object("schema");
my %abstract;

foreach (in $abstractSchema){
    $abstract{$_->{class}}++;
}

while (($type,$aantal)=each %abstract){
    print $type,"\t",$aantal,"\n";
  }


