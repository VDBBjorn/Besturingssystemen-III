use Win32::OLE qw(in);  #inladen van de functie "in"

$conf = Win32::OLE->new("CDO.Configuration");
 
foreach (in $conf->{Fields}){
   printf "%s = %s\n",$_->{Name},$_->{Value};
}


