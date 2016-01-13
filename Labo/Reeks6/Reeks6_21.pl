use Win32::OLE::Const;

@ARGV=( "_UF_");
$zoek = @ARGV ? $ARGV[0] : ".";

print "Alle constanten met de string : $zoek \n";

$wd = Win32::OLE::Const->Load("Active DS Type Library");
while (($key,$value)=each %{$wd}){
    print "$key :$value\n"  if $key =~ /$zoek/;
}


