#. . . implementatie functie bind_object zie sectie 5 in reeks 6
#. . . implementatie functie valueattribuut: zie oefening 1

@ARGV == 1 or die "geef als enige parameter de naam van de ou relatief t.o.v. de container ou=labo,dc=hogent,dc=hogent,dc=be\n";
my $ou_naam=$ARGV[0];
my $RootObj=bind_object("RootDSE"); #serverless Binding
$RootObj->getinfo();

my $ou=bind_object("ou=".$ou_naam.",ou=labo,".$RootObj->{defaultNamingContext}); #je eigen container wordt opgehaald

$ou->{Filter} = ["organizationalUnit"];  #enkel in de organizational unit wissen

foreach (in $ou) {
  wis($_);                      #wis alles in de container
  print $_->{adspath}. " wissen ok (j=ja) ?\n"; #container zelf wissen
  chomp($antw=<STDIN>);
  if ($antw eq "j") {
    $ou->delete ($_->{class},$_->{name});
    if (Win32::OLE->LastError eq 0) {    
      print  $_->{adspath}," wordt gewist\n";
    } else {
      print Win32::OLE->LastError,"\n";
    }
  }
}

sub wis{
   my $cont=shift;
   foreach (in $cont){
     print $_->{adspath}. " wissen ok (j=ja) ?\n";
     chomp($antw=<STDIN>);
     if ($antw eq "j"){
       wis($_);
       $cont->delete ($_->{class},$_->{name});
       if (Win32::OLE->LastError eq 0) {    
         print  $_->{adspath}," wordt gewist\n";
       } else {
         print Win32::OLE->LastError,"\n";
       }
     }
   }
 }

