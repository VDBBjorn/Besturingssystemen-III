use Win32::OLE::Const;

@ARGV=("Excel.Sheet","Scripting.FileSystemObject","CDO.Message"); #lukt altijd.

for $comObjectNaam (@ARGV) {
  print  "\n**********",$comObjectNaam,"***********\n";
  $object = Win32::OLE->new($comObjectNaam);
  %wd = %{Win32::OLE::Const->Load($object)}; #direct in een hash stoppen

  foreach (sort {$a cmp $b} keys %wd) {
    printf ("%30s : %s\n",$_,$wd{$_});
  }  
}



